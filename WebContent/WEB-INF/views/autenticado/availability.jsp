<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.aura.availability.models.Availability" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Aura - Disponibilidade</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <script>
        function openModal(action, id, dia, inicio, fim) {
            document.getElementById('modal-overlay').classList.remove('hidden');
            document.getElementById('modal-overlay').classList.add('flex');
            document.getElementById('modal-title').innerText = action === 'edit' ? 'Editar Horário' : 'Adicionar Horário';
            document.getElementById('input-id').value = id || '';
            document.getElementById('select-dia').value = dia || '1';
            document.getElementById('input-inicio').value = inicio || '';
            document.getElementById('input-fim').value = fim || '';
            document.getElementById('form-availability').action =
                '${pageContext.request.contextPath}/autenticado/availability/' + (action === 'edit' ? 'edit' : 'save');
        }

        function closeModal() {
            document.getElementById('modal-overlay').classList.add('hidden');
            document.getElementById('modal-overlay').classList.remove('flex');
        }

        function toggleStatus(id) {
            document.getElementById('form-status-' + id).submit();
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.getElementById('modal-overlay').addEventListener('click', function (e) {
                if (e.target === this) closeModal();
            });
        });
    </script>
</head>
<body class="bg-white min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="financial" />

<div class="flex flex-1">

    <t:menu paginaAtiva="agenda" />

    <main class="flex-1 p-10 space-y-8">

        <!-- HEADER -->
        <div class="mb-8 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5">

            <div>

                <p class="text-sm font-medium text-violet-600 mb-1">
                    Aura
                </p>

                <h1 class="text-3xl font-black text-slate-900">
                    Minha Disponibilidade
                </h1>

                <p class="text-slate-500 mt-2">
                    Organize seus horários e gerencie sua agenda de mentorias.
                </p>

            </div>

            <button onclick="openModal('new')"
                    class="inline-flex items-center justify-center gap-2
                           bg-gradient-to-br from-violet-600 to-violet-800
                           hover:opacity-95
                           text-white font-semibold
                           px-6 py-3 rounded-2xl
                           shadow-[0_10px_24px_rgba(109,40,217,0.22)]
                           transition hover:-translate-y-0.5
                           cursor-pointer">

                <span class="text-lg leading-none">+</span>

                Adicionar Horário

            </button>

        </div>

        <% if(request.getAttribute("error") != null) { %>

        <div class="bg-red-50 border border-red-200
                    text-red-700 rounded-2xl
                    px-5 py-4 mb-6 shadow-sm">

            <strong>Atenção:</strong>
            <%= request.getAttribute("error") %>

        </div>

        <% } %>

        <%
            List<Availability> lista = (List<Availability>) request.getAttribute("schedules");
            String[] nomeDias = {"Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"};

            Map<Integer, List<Availability>> porDia = new LinkedHashMap<>();

            for (int i = 1; i <= 7; i++) {
                porDia.put(i, new ArrayList<>());
            }

            if (lista != null) {
                for (Availability h : lista) {
                    int val = h.getDayWeek().getValue();

                    if (porDia.containsKey(val)) {
                        porDia.get(val).add(h);
                    }
                }
            }
        %>

        <!-- CALENDÁRIO -->
        <div class="bg-white overflow-hidden">

            <!-- HEADER DOS DIAS -->
            <div class="grid grid-cols-7 bg-white border-b border-violet-100">

                <%
                    for (int dia = 1; dia <= 7; dia++) {
                        String nomeDia = nomeDias[dia - 1];
                %>

                <div class="py-4 text-center border-r border-violet-100 last:border-r-0">

                    <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold">
                        <%= nomeDia.substring(0,3) %>
                    </p>

                    <h3 class="text-sm font-bold text-slate-700 mt-1">
                        <%= nomeDia %>
                    </h3>

                </div>

                <% } %>

            </div>

            <!-- GRID -->
            <div class="grid grid-cols-7 min-h-[650px] bg-white">

                <%
                    for (int dia = 1; dia <= 7; dia++) {

                        List<Availability> horariosDia = porDia.get(dia);
                %>

                <!-- COLUNA -->
                <div class="border-r border-violet-100 last:border-r-0
                    flex flex-col">

                    <!-- ÁREA DOS HORÁRIOS -->
                    <div class="flex flex-col flex-1 p-3 gap-3">

                        <% if (horariosDia.isEmpty()) { %>

                        <div class="flex-1 flex items-center justify-center">

                            <p class="text-xs text-slate-400">
                                Sem horários
                            </p>

                        </div>

                        <% } %>

                        <% for (Availability h : horariosDia) { %>

                        <!-- CARD HORÁRIO -->
                        <div class="<%= h.isActive()
                            ? "bg-violet-50 border-violet-200"
                            : "bg-slate-50 border-slate-200 opacity-60" %>
                            border rounded-2xl p-3
                            flex flex-col gap-3
                            hover:shadow-md
                            transition-all">

                            <!-- HORA -->
                            <div>

                                <p class="text-sm font-bold text-slate-800">
                                    <%= h.getHourStart() %>
                                </p>

                                <p class="text-xs text-slate-400 mt-0.5">
                                    até <%= h.getHourEnd() %>
                                </p>

                            </div>

                            <!-- STATUS -->
                            <form id="form-status-<%= h.getId() %>"
                                  action="${pageContext.request.contextPath}/autenticado/availability/toggle"
                                  method="POST"
                                  class="flex items-center gap-2">

                                <input type="hidden"
                                       name="id"
                                       value="<%= h.getId() %>">

                                <input type="checkbox"
                                    <%= h.isActive() ? "checked" : "" %>
                                       onchange="toggleStatus(<%= h.getId() %>)"
                                       class="w-4 h-4 accent-violet-600 cursor-pointer">

                                <span class="text-xs text-slate-500 font-medium">

                            <%= h.isActive()
                                    ? "Disponível"
                                    : "Indisponível" %>

                        </span>

                            </form>

                            <!-- AÇÕES -->
                            <div class="flex gap-2">

                                <button onclick="openModal(
                                        'edit',
                                        '<%= h.getId() %>',
                                        '<%= h.getDayWeek().getValue() %>',
                                        '<%= h.getHourStart() %>',
                                        '<%= h.getHourEnd() %>')"

                                        class="flex-1 py-2 rounded-xl
                                       bg-white border border-violet-200
                                       text-violet-700
                                       text-xs font-semibold
                                       hover:bg-violet-100
                                       transition cursor-pointer">

                                    Editar

                                </button>

                                <form action="${pageContext.request.contextPath}/autenticado/availability/remove"
                                      method="POST"
                                      class="flex-1">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= h.getId() %>">

                                    <button type="submit"
                                            onclick="return confirm('Excluir este horário?')"

                                            class="w-full py-2 rounded-xl
                                           bg-white border border-red-200
                                           text-red-500
                                           text-xs font-semibold
                                           hover:bg-red-50
                                           transition cursor-pointer">

                                        Remover

                                    </button>

                                </form>

                            </div>

                        </div>

                        <% } %>

                        <!-- BOTÃO ADD -->
                        <button onclick="openModal('new', '', '<%= dia %>')"

                                class="mt-auto border border-dashed border-slate-200
                               rounded-2xl py-3
                               text-sm text-slate-400
                               hover:border-violet-300
                               hover:text-violet-600
                               hover:bg-violet-50
                               transition-all cursor-pointer">

                            + Adicionar

                        </button>

                    </div>

                </div>

                <% } %>

            </div>

        </div>

    </main>

</div>

<!-- MODAL -->
<div id="modal-overlay"
     class="hidden fixed inset-0 z-50
            bg-black/40 backdrop-blur-sm
            items-center justify-center">

    <div class="bg-white w-full max-w-md
                rounded-[28px]
                border border-slate-200
                shadow-2xl
                p-7 mx-4">

        <!-- TITLE -->
        <div class="mb-6">

            <p class="text-sm font-medium text-violet-600 mb-1">
                Infinity Aura
            </p>

            <h3 id="modal-title"
                class="text-2xl font-black text-slate-900">

                Adicionar Horário

            </h3>

        </div>

        <!-- FORM -->
        <form id="form-availability"
              action="${pageContext.request.contextPath}/autenticado/availability/save"
              method="POST"
              class="flex flex-col gap-5">

            <input type="hidden"
                   name="id"
                   id="input-id"
                   value="">

            <!-- DIA -->
            <div class="flex flex-col gap-2">

                <label class="text-sm font-semibold text-slate-600">
                    Dia da semana
                </label>

                <select name="dayOfWeek"
                        id="select-dia"
                        required

                        class="bg-[#fafbff]
                               border border-[#edf0f7]
                               rounded-2xl
                               px-4 py-3
                               text-sm
                               focus:outline-none
                               focus:border-violet-400">

                    <option value="1">Segunda</option>
                    <option value="2">Terça</option>
                    <option value="3">Quarta</option>
                    <option value="4">Quinta</option>
                    <option value="5">Sexta</option>
                    <option value="6">Sábado</option>
                    <option value="7">Domingo</option>

                </select>

            </div>

            <!-- INICIO -->
            <div class="flex flex-col gap-2">

                <label class="text-sm font-semibold text-slate-600">
                    Horário de início
                </label>

                <input type="time"
                       name="startTime"
                       id="input-inicio"
                       required

                       class="bg-[#fafbff]
                              border border-[#edf0f7]
                              rounded-2xl
                              px-4 py-3
                              text-sm
                              focus:outline-none
                              focus:border-violet-400">

            </div>

            <!-- FIM -->
            <div class="flex flex-col gap-2">

                <label class="text-sm font-semibold text-slate-600">
                    Horário de fim
                </label>

                <input type="time"
                       name="endTime"
                       id="input-fim"
                       required

                       class="bg-[#fafbff]
                              border border-[#edf0f7]
                              rounded-2xl
                              px-4 py-3
                              text-sm
                              focus:outline-none
                              focus:border-violet-400">

            </div>

            <!-- BUTTONS -->
            <div class="flex justify-end gap-3 pt-2">

                <button type="button"
                        onclick="closeModal()"

                        class="px-5 py-3
                               rounded-2xl
                               bg-slate-100
                               text-slate-500
                               font-medium
                               hover:bg-slate-200
                               transition cursor-pointer">

                    Cancelar

                </button>

                <button type="submit"

                        class="px-5 py-3
                               rounded-2xl
                               bg-gradient-to-br
                               from-violet-600
                               to-violet-800
                               text-white
                               font-semibold
                               shadow-[0_10px_24px_rgba(109,40,217,0.22)]
                               hover:opacity-95
                               transition cursor-pointer">

                    Confirmar

                </button>

            </div>

        </form>

    </div>

</div>

</body>
</html>