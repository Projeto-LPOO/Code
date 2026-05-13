<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.aura.availability.models.Availability" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%
    LocalDate hoje = LocalDate.now();
%>

<%
    DateTimeFormatter dayFmt = DateTimeFormatter.ofPattern("dd");
    DateTimeFormatter fullFmt = DateTimeFormatter.ofPattern("dd/MM");

    String weekParam = request.getParameter("week");

    LocalDate baseDate;

    if (weekParam != null) {
        baseDate = LocalDate.parse(weekParam).with(DayOfWeek.MONDAY);
    } else {
        baseDate = LocalDate.now().with(DayOfWeek.MONDAY);
    }

    LocalDate[] diasSemana = new LocalDate[7];

    for (int i = 0; i < 7; i++) {
        diasSemana[i] = baseDate.plusDays(i);
    }

    LocalDate nextWeek = baseDate.plusDays(7);
    LocalDate prevWeek = baseDate.minusDays(7);

    List<Availability> lista = (List<Availability>) request.getAttribute("schedules");

    String[] nomeDias = {
            "Segunda", "Terça", "Quarta",
            "Quinta", "Sexta", "Sábado", "Domingo"
    };

    Map<Integer, List<Availability>> porDia = new LinkedHashMap<>();

    for (int i = 1; i <= 7; i++) {
        porDia.put(i, new ArrayList<>());
    }

    if (lista != null) {
        for (Availability h : lista) {
            int val = h.getDayWeek().getValue();
            porDia.get(val).add(h);
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Calendário Semanal</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <script>
        function openModal(action, id, dia, inicio, fim) {
            document.getElementById('modal-overlay').classList.remove('hidden');
            document.getElementById('modal-overlay').classList.add('flex');

            document.getElementById('modal-title').innerText =
                action === 'edit' ? 'Editar Horário' : 'Adicionar Horário';

            document.getElementById('input-id').value = id || '';
            document.getElementById('select-dia').value = dia || '1';
            document.getElementById('input-inicio').value = inicio || '';
            document.getElementById('input-fim').value = fim || '';

            document.getElementById('form-availability').action =
                '${pageContext.request.contextPath}/autenticado/availability/' +
                (action === 'edit' ? 'edit' : 'save');
        }

        function closeModal() {
            document.getElementById('modal-overlay').classList.add('hidden');
            document.getElementById('modal-overlay').classList.remove('flex');
        }

        function toggleStatus(id) {
            document.getElementById('form-status-' + id).submit();
        }
    </script>
</head>

<body class="bg-white min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="agenda" />

<div class="flex flex-1">

    <t:menu paginaAtiva="agenda" />

    <main class="flex-1 p-10">

        <!-- HEADER -->
        <div class="flex items-center justify-between mb-6">

            <a href="?week=<%= prevWeek %>"
               class="px-4 py-2 bg-slate-100 rounded-xl hover:bg-slate-200">
                ← Semana anterior
            </a>

            <div class="text-center">
                <h1 class="text-2xl font-black text-slate-900">
                    Calendário Semanal
                </h1>
                <p class="text-sm text-slate-500">
                    <%= diasSemana[0].format(fullFmt) %> até <%= diasSemana[6].format(fullFmt) %>
                </p>
            </div>

            <a href="?week=<%= nextWeek %>"
               class="px-4 py-2 bg-slate-100 rounded-xl hover:bg-slate-200">
                Próxima semana →
            </a>

        </div>

        <!-- GRID SEMANAL -->
        <div class="grid grid-cols-7 gap-3">

            <%
                for (int dia = 1; dia <= 7; dia++) {

                    LocalDate data = diasSemana[dia - 1];
                    boolean isHoje = data.equals(hoje);
                    List<Availability> horariosDia = porDia.get(dia);
            %>

            <div class="
    border rounded-2xl flex flex-col min-h-[650px]
    <%= isHoje
        ? "border-violet-500 bg-violet-50 shadow-md"
        : "border-violet-100 bg-white" %>
">
                <!-- HEADER DIA -->
                <div class="p-3 text-center border-b border-violet-100">

                    <p class="text-xs text-slate-400 uppercase font-semibold">
                        <%= nomeDias[dia - 1].substring(0,3) %>
                    </p>

                    <p class="text-lg font-bold text-slate-800">
                        <%= data.format(dayFmt) %>
                    </p>

                </div>

                <!-- HORÁRIOS -->
                <div class="p-3 flex flex-col gap-3 flex-1 overflow-y-auto">

                    <% if (horariosDia == null || horariosDia.isEmpty()) { %>
                    <p class="text-xs text-slate-400 text-center mt-10">
                        Sem horários
                    </p>
                    <% } %>

                    <% for (Availability h : horariosDia) { %>

                    <div class="<%= h.isAvailable()
                ? "bg-violet-50 border-violet-200"
                : "bg-slate-50 opacity-60" %>
                border rounded-xl p-3 space-y-2">

                        <div class="font-bold text-sm">
                            <%= h.getHourStart() %> - <%= h.getHourEnd() %>
                        </div>

                        <form id="form-status-<%= h.getId() %>"
                              action="${pageContext.request.contextPath}/autenticado/availability/toggle"
                              method="POST"
                              class="flex items-center gap-2">

                            <input type="hidden" name="id" value="<%= h.getId() %>">

                            <input type="checkbox"
                                <%= h.isAvailable() ? "checked" : "" %>
                                   onchange="toggleStatus(<%= h.getId() %>)"
                                   class="accent-violet-600">

                            <span class="text-xs text-slate-500">
                    <%= h.isAvailable() ? "Disponível" : "Indisponível" %>
                </span>

                        </form>

                        <div class="flex gap-2">

                            <button onclick="openModal(
                                    'edit',
                                    '<%= h.getId() %>',
                                    '<%= h.getDayWeek().getValue() %>',
                                    '<%= h.getHourStart() %>',
                                    '<%= h.getHourEnd() %>')"

                                    class="flex-1 text-xs py-2 border rounded-lg hover:bg-violet-100">

                                Editar

                            </button>

                            <form action="${pageContext.request.contextPath}/autenticado/availability/remove"
                                  method="POST"
                                  class="flex-1">

                                <input type="hidden" name="id" value="<%= h.getId() %>">

                                <button type="submit"
                                        onclick="return confirm('Excluir?')"
                                        class="w-full text-xs py-2 border rounded-lg text-red-500 hover:bg-red-50">

                                    Remover

                                </button>

                            </form>

                        </div>

                    </div>

                    <% } %>

                    <button onclick="openModal('new', '', '<%= dia %>')"
                            class="mt-auto border border-dashed rounded-xl py-2 text-xs text-slate-400 hover:text-violet-600">
                        + Adicionar
                    </button>

                </div>

            </div>

            <% } %>

        </div>

    </main>
</div>

<!-- MODAL -->
<div id="modal-overlay"
     class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm items-center justify-center">

    <div class="bg-white w-full max-w-md rounded-3xl p-6">

        <h2 id="modal-title" class="text-xl font-bold mb-4">
            Adicionar Horário
        </h2>

        <form id="form-availability"
              method="POST"
              class="space-y-4">

            <input type="hidden" id="input-id" name="id">

            <select id="select-dia" name="dayOfWeek" class="w-full p-3 border rounded-xl">
                <option value="1">Segunda</option>
                <option value="2">Terça</option>
                <option value="3">Quarta</option>
                <option value="4">Quinta</option>
                <option value="5">Sexta</option>
                <option value="6">Sábado</option>
                <option value="7">Domingo</option>
            </select>

            <input type="time" id="input-inicio" name="startTime" class="w-full p-3 border rounded-xl">
            <input type="time" id="input-fim" name="endTime" class="w-full p-3 border rounded-xl">

            <div class="flex justify-end gap-3">

                <button type="button" onclick="closeModal()"
                        class="px-4 py-2 bg-slate-100 rounded-xl">
                    Cancelar
                </button>

                <button type="submit"
                        class="px-4 py-2 bg-violet-600 text-white rounded-xl">
                    Salvar
                </button>

            </div>

        </form>

    </div>

</div>

</body>
</html>