<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.aura.availability.models.Availability" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%
    LocalDate hoje = LocalDate.now();
    DateTimeFormatter dayFmt   = DateTimeFormatter.ofPattern("dd");
    DateTimeFormatter fullFmt  = DateTimeFormatter.ofPattern("dd/MM");
    DateTimeFormatter hourFmt  = DateTimeFormatter.ofPattern("HH:mm");

    String weekParam = request.getParameter("week");
    LocalDate baseDate = (weekParam != null)
            ? LocalDate.parse(weekParam).with(DayOfWeek.MONDAY)
            : LocalDate.now().with(DayOfWeek.MONDAY);

    LocalDate[] diasSemana = new LocalDate[7];
    for (int i = 0; i < 7; i++) diasSemana[i] = baseDate.plusDays(i);

    LocalDate nextWeek = baseDate.plusDays(7);
    LocalDate prevWeek = baseDate.minusDays(7);

    List<Availability> lista    = (List<Availability>) request.getAttribute("schedules");
    List<Meeting>      meetings = (List<Meeting>)      request.getAttribute("meetings");

    String[] nomeDias = {"Segunda","Terça","Quarta","Quinta","Sexta","Sábado","Domingo"};

    // Agrupa disponibilidades por dia da semana (1=Seg … 7=Dom)
    Map<Integer, List<Availability>> porDia = new LinkedHashMap<>();
    for (int i = 1; i <= 7; i++) porDia.put(i, new ArrayList<>());
    if (lista != null) {
        for (Availability h : lista) porDia.get(h.getDayWeek().getValue()).add(h);
    }

    // Agrupa meetings por data
    Map<String, List<Meeting>> meetingsPorData = new LinkedHashMap<>();
    if (meetings != null) {
        for (Meeting m : meetings) {
            String key = m.getDayTime().toLocalDate().toString();
            meetingsPorData.computeIfAbsent(key, k -> new ArrayList<>()).add(m);
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Agenda</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script>
        function openModal(action, id, dia, inicio, fim) {
            document.getElementById('modal-overlay').classList.replace('hidden','flex');
            document.getElementById('modal-title').innerText = action === 'edit' ? 'Editar Horário' : 'Adicionar Horário';
            document.getElementById('input-id').value    = id    || '';
            document.getElementById('select-dia').value  = dia   || '1';
            document.getElementById('input-inicio').value = inicio || '';
            document.getElementById('input-fim').value   = fim   || '';
            document.getElementById('form-availability').action =
                '${pageContext.request.contextPath}/autenticado/availability/' + (action === 'edit' ? 'edit' : 'save');
        }
        function closeModal() {
            document.getElementById('modal-overlay').classList.replace('flex','hidden');
        }
        function toggleStatus(id) {
            document.getElementById('form-status-' + id).submit();
        }
    </script>
</head>

<body class="bg-slate-50 min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="agenda" />

<div class="flex flex-1">
    <t:menu paginaAtiva="agenda" />

    <!-- CONTEÚDO PRINCIPAL -->
    <div class="flex flex-1 overflow-hidden">

        <!-- ===================== SIDEBAR: DISPONIBILIDADES ===================== -->
        <aside class="w-64 shrink-0 bg-white border-r border-slate-200 flex flex-col overflow-y-auto">

            <div class="p-5 border-b border-slate-100">
                <h2 class="text-sm font-semibold text-slate-500 uppercase tracking-wide">Disponibilidades</h2>
                <p class="text-xs text-slate-400 mt-1">Horários por dia da semana</p>
            </div>

            <div class="flex flex-col gap-1 p-4">
                <% for (int dia = 1; dia <= 7; dia++) {
                    List<Availability> horariosDia = porDia.get(dia);
                %>
                <div class="mb-3">
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-xs font-semibold text-slate-600"><%= nomeDias[dia - 1] %></span>
                        <button
                                onclick="openModal('new','','<%= dia %>')"
                                class="text-xs text-violet-500 hover:text-violet-700 font-medium"
                        >+ add</button>
                    </div>

                    <% if (horariosDia == null || horariosDia.isEmpty()) { %>
                    <p class="text-xs text-slate-300 pl-1">Sem horários</p>
                    <% } else { %>
                    <% for (Availability h : horariosDia) { %>
                    <div class="
                            flex items-center justify-between
                            px-3 py-2 rounded-lg mb-1
                            <%= h.isAvailable() ? "bg-violet-50" : "bg-slate-50 opacity-60" %>
                        ">
                        <div>
                                <span class="text-xs font-semibold <%= h.isAvailable() ? "text-violet-700" : "text-slate-400" %>">
                                    <%= h.getHourStart().format(hourFmt) %> – <%= h.getHourEnd().format(hourFmt) %>
                                </span>
                            <span class="block text-xs <%= h.isAvailable() ? "text-violet-400" : "text-slate-300" %>">
                                    <%= h.isAvailable() ? "Disponível" : "Indisponível" %>
                                </span>
                        </div>
                        <div class="flex items-center gap-1">
                            <!-- toggle -->
                            <form id="form-status-<%= h.getId() %>"
                                  action="${pageContext.request.contextPath}/autenticado/availability/toggle"
                                  method="POST">
                                <input type="hidden" name="id" value="<%= h.getId() %>">
                                <input type="checkbox"
                                    <%= h.isAvailable() ? "checked" : "" %>
                                       onchange="toggleStatus(<%= h.getId() %>)"
                                       class="accent-violet-600 cursor-pointer">
                            </form>
                            <!-- editar -->
                            <button onclick="openModal(
                                    'edit',
                                    '<%= h.getId() %>',
                                    '<%= h.getDayWeek().getValue() %>',
                                    '<%= h.getHourStart().format(hourFmt) %>',
                                    '<%= h.getHourEnd().format(hourFmt) %>')"
                                    class="text-slate-400 hover:text-violet-600 text-xs px-1">✎</button>
                            <!-- remover -->
                            <form action="${pageContext.request.contextPath}/autenticado/availability/remove" method="POST">
                                <input type="hidden" name="id" value="<%= h.getId() %>">
                                <button type="submit"
                                        onclick="return confirm('Excluir?')"
                                        class="text-slate-300 hover:text-red-500 text-xs px-1">✕</button>
                            </form>
                        </div>
                    </div>
                    <% } %>
                    <% } %>
                </div>
                <% } %>
            </div>

        </aside>

        <!-- ===================== MAIN: CALENDÁRIO DE MEETINGS ===================== -->
        <main class="flex-1 p-8 overflow-y-auto">

            <!-- Header navegação -->
            <div class="flex items-center justify-between mb-6">
                <a href="?week=<%= prevWeek %>"
                   class="px-4 py-2 bg-white border border-slate-200 rounded-xl text-sm hover:bg-slate-50">
                    ← Semana anterior
                </a>
                <div class="text-center">
                    <h1 class="text-xl font-bold text-slate-900">Meetings da semana</h1>
                    <p class="text-sm text-slate-400">
                        <%= diasSemana[0].format(fullFmt) %> até <%= diasSemana[6].format(fullFmt) %>
                    </p>
                </div>
                <a href="?week=<%= nextWeek %>"
                   class="px-4 py-2 bg-white border border-slate-200 rounded-xl text-sm hover:bg-slate-50">
                    Próxima semana →
                </a>
            </div>

            <!-- Grid 7 dias -->
            <div class="grid grid-cols-7 gap-3">
                <% for (int dia = 1; dia <= 7; dia++) {
                    LocalDate data     = diasSemana[dia - 1];
                    boolean   isHoje   = data.equals(hoje);
                    String    dataKey  = data.toString();
                    List<Meeting> dayMeetings = meetingsPorData.getOrDefault(dataKey, List.of());
                %>
                <div class="
                    border rounded-2xl flex flex-col min-h-[500px]
                    <%= isHoje ? "border-violet-400 bg-violet-50 shadow" : "border-slate-100 bg-white" %>
                ">
                    <!-- Cabeçalho do dia -->
                    <div class="p-3 text-center border-b <%= isHoje ? "border-violet-200" : "border-slate-100" %>">
                        <p class="text-xs text-slate-400 uppercase font-semibold">
                            <%= nomeDias[dia - 1].substring(0, 3) %>
                        </p>
                        <p class="text-lg font-bold <%= isHoje ? "text-violet-700" : "text-slate-800" %>">
                            <%= data.format(dayFmt) %>
                        </p>
                        <% if (!dayMeetings.isEmpty()) { %>
                        <span class="inline-block mt-1 text-xs px-2 py-0.5 rounded-full
                            bg-green-100 text-green-700 font-semibold">
                            <%= dayMeetings.size() %> meeting<%= dayMeetings.size() > 1 ? "s" : "" %>
                        </span>
                        <% } %>
                    </div>

                    <!-- Lista de meetings -->
                    <div class="p-3 flex flex-col gap-2 flex-1 overflow-y-auto">
                        <% if (dayMeetings.isEmpty()) { %>
                        <p class="text-xs text-slate-300 text-center mt-8">Sem meetings</p>
                        <% } else {
                            for (Meeting m : dayMeetings) { %>
                        <div class="bg-white border border-slate-100 rounded-xl p-3 shadow-sm">
                            <p class="text-xs font-bold text-violet-600">
                                <%= m.getDayTime().toLocalTime().format(hourFmt) %>
                                <% LocalTime fim = m.getDayTime().toLocalTime().plusMinutes(m.getDurationMinutes()); %>
                                – <%= fim.format(hourFmt) %>
                            </p>
                            
                            <p class="text-xs text-slate-400"><%= m.getDurationMinutes() %> min</p>
                        </div>
                        <% } } %>
                    </div>
                </div>
                <% } %>
            </div>

        </main>
    </div>
</div>

<!-- MODAL -->
<div id="modal-overlay"
     class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm items-center justify-center z-50">
    <div class="bg-white w-full max-w-md rounded-3xl p-6 shadow-xl">
        <h2 id="modal-title" class="text-xl font-bold mb-4">Adicionar Horário</h2>
        <form id="form-availability" method="POST" class="space-y-4">
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
            <input type="time" id="input-fim"    name="endTime"   class="w-full p-3 border rounded-xl">
            <div class="flex justify-end gap-3">
                <button type="button" onclick="closeModal()"
                        class="px-4 py-2 bg-slate-100 rounded-xl hover:bg-slate-200">Cancelar</button>
                <button type="submit"
                        class="px-4 py-2 bg-violet-600 text-white rounded-xl hover:bg-violet-700">Salvar</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>