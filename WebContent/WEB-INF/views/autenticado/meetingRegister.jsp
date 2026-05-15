<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ page import="com.aura.user.models.CommercialUser" %>
<%@ page import="com.aura.category.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aura.availability.models.Availability" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
    User loggedUser        = (User) session.getAttribute("user");
    CommercialUser mentor  = (CommercialUser) request.getAttribute("mentor");
    List<Category> mentorCategories = (List<Category>) request.getAttribute("mentorCategories");
    Integer preselectedTeacherId    = (Integer) request.getAttribute("preselectedTeacherId");
    Integer userBalance    = (Integer) request.getAttribute("userBalance");
    if (userBalance == null) userBalance = 0;
    String duracaoError    = (String) request.getAttribute("duracao");
    List<Availability> availabilities =
            (List<Availability>) request.getAttribute("availabilities");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendar Meeting | Infinity Aura</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-gray-100 min-h-screen flex"
      data-context="${pageContext.request.contextPath}"
      data-teacher-id="<%= preselectedTeacherId != null ? preselectedTeacherId : "" %>">

<%-- Sidebar via tag padrão do sistema --%>
<t:menu paginaAtiva="meetings" />

<main class="flex-1 min-w-0 p-8 flex flex-col gap-0">

    <%-- Cabeçalho --%>
    <div class="flex items-center justify-between mb-7">
        <div>
            <h1 class="text-2xl font-bold text-gray-900">Agendar Meeting</h1>
            <p class="text-sm text-gray-500 mt-1">Escolha o tipo, data, horário e preencha os detalhes da sessão.</p>
        </div>
        <div class="flex items-center gap-2 border border-gray-200 rounded-full px-4 py-1.5 bg-white text-sm font-semibold text-gray-700">
            BALANCE <span class="text-violet-600 font-bold" id="badgeBalance"><%= userBalance %> CS</span>
        </div>
    </div>

    <%-- Erro servidor --%>
    <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm mb-5">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${mentor == null}">
            <div class="bg-white border border-gray-200 rounded-2xl p-16 text-center">
                <p class="text-base font-semibold text-gray-700 mb-2">Nenhum professor selecionado</p>
                <p class="text-sm text-gray-400 mb-6">Explore os professores disponíveis e escolha um para agendar.</p>
                <a href="${pageContext.request.contextPath}/autenticado/users"
                   class="inline-block bg-violet-600 hover:bg-violet-700 text-white font-semibold text-sm px-6 py-2.5 rounded-xl transition-colors">
                    Explorar Professores
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <form id="meetingForm"
                  action="${pageContext.request.contextPath}/autenticado/meeting/register"
                  method="post">

                <input type="hidden" name="teacherId"  value="${mentor.id}">
                <input type="hidden" name="interestId" id="hiddenInterestId" value="">
                <input type="hidden" name="duracao"    id="hiddenDuracao"    value="60">

                <div class="grid grid-cols-[1fr_300px] gap-6 items-start">

                        <%-- ── COLUNA PRINCIPAL ── --%>
                    <div class="flex flex-col gap-4">

                            <%-- Professor --%>
                        <div class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                            <div class="flex items-center justify-between gap-3">
                                <div>
                                    <h2 class="text-base font-bold text-gray-900">${mentor.name}</h2>
                                    <p class="text-sm text-gray-500 mt-0.5">${mentor.email}</p>
                                </div>
                                <span class="text-xs font-semibold bg-blue-50 text-blue-700 px-3 py-1 rounded-full uppercase tracking-wide whitespace-nowrap">✓ Professor Verificado</span>
                            </div>
                        </div>

                            <%-- Tipo --%>
                        <div class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                            <h3 class="text-sm font-bold text-gray-900 mb-4">Tipo de Meeting</h3>
                            <div class="grid grid-cols-2 gap-3" id="tipoOptions">
                                <label class="flex items-center gap-2.5 px-4 py-3.5 border-2 border-violet-600 bg-violet-50 rounded-xl cursor-pointer text-sm font-semibold text-violet-700 select-none transition-all mr-tipo-opt mr-tipo-selected">
                                    <input type="radio" name="tipo" value="online" checked class="w-4 h-4 accent-violet-600 shrink-0">
                                    Online
                                </label>
                                <label class="flex items-center gap-2.5 px-4 py-3.5 border-2 border-gray-200 rounded-xl cursor-pointer text-sm font-medium text-gray-600 select-none transition-all mr-tipo-opt hover:border-violet-300">
                                    <input type="radio" name="tipo" value="presencial" class="w-4 h-4 accent-violet-600 shrink-0">
                                    Presencial
                                </label>
                            </div>
                        </div>

                            <%-- Categoria e Interesse --%>
                        <div class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                            <h3 class="text-sm font-bold text-gray-900 mb-4">Área de Conhecimento</h3>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="selectCategoria">Categoria</label>
                                    <select id="selectCategoria" name="categoriaId"
                                            class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 bg-white outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                        <option value="">-- Selecione a categoria --</option>
                                        <c:forEach var="cat" items="${mentorCategories}">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="selectInteresse">Interesse</label>
                                    <select id="selectInteresse" name="interestIdSelect" disabled
                                            class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 bg-white outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full disabled:opacity-50 disabled:cursor-not-allowed disabled:bg-gray-50">
                                        <option value="">-- Selecione primeiro a categoria --</option>
                                    </select>
                                </div>
                            </div>
                            <span class="text-red-500 text-xs mt-1 block min-h-[1em]" id="erro-interesse"></span>
                        </div>

                            <%-- Disponibilidade --%>
                                    <%-- Disponibilidade --%>
                                <div class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                                    <div class="flex items-center justify-between mb-4">
                                        <div>
                                            <h3 class="text-sm font-bold text-gray-900">
                                                Disponibilidade do Professor
                                            </h3>
                                            <p class="text-xs text-gray-400 mt-1">
                                                Horários recorrentes disponíveis para agendamento
                                            </p>
                                        </div>

                                        <span class="text-[11px] font-semibold px-3 py-1 rounded-full bg-violet-50 text-violet-700">
            ${availabilities.size()} horários
        </span>
                                    </div>

                                    <c:choose>

                                        <c:when test="${empty availabilities}">
                                            <div class="border border-dashed border-gray-200 rounded-xl py-8 text-center">
                                                <p class="text-sm text-gray-500">
                                                    Nenhuma disponibilidade cadastrada.
                                                </p>
                                            </div>
                                        </c:when>

                                        <c:otherwise>

                                            <div class="overflow-hidden border border-gray-200 rounded-xl">

                                                <table class="w-full text-sm">

                                                    <thead class="bg-gray-50 border-b border-gray-200">
                                                    <tr>
                                                        <th class="text-left px-4 py-3 font-semibold text-gray-500 uppercase tracking-wide text-xs">
                                                            Dia
                                                        </th>

                                                        <th class="text-left px-4 py-3 font-semibold text-gray-500 uppercase tracking-wide text-xs">
                                                            Início
                                                        </th>

                                                        <th class="text-left px-4 py-3 font-semibold text-gray-500 uppercase tracking-wide text-xs">
                                                            Fim
                                                        </th>

<%--                                                        <th class="text-left px-4 py-3 font-semibold text-gray-500 uppercase tracking-wide text-xs">--%>
<%--                                                            Status--%>
<%--                                                        </th>--%>
                                                    </tr>
                                                    </thead>

                                                    <tbody class="divide-y divide-gray-100">

                                                    <c:forEach var="slot" items="${availabilities}">

                                                        <tr class="hover:bg-gray-50 transition-colors">

                                                            <td class="px-4 py-3 font-medium text-gray-900">
                                                                <c:choose>
                                                                    <c:when test="${slot.dayWeek == 'MONDAY'}">Segunda-feira</c:when>
                                                                    <c:when test="${slot.dayWeek == 'TUESDAY'}">Terça-feira</c:when>
                                                                    <c:when test="${slot.dayWeek == 'WEDNESDAY'}">Quarta-feira</c:when>
                                                                    <c:when test="${slot.dayWeek == 'THURSDAY'}">Quinta-feira</c:when>
                                                                    <c:when test="${slot.dayWeek == 'FRIDAY'}">Sexta-feira</c:when>
                                                                    <c:when test="${slot.dayWeek == 'SATURDAY'}">Sábado</c:when>
                                                                    <c:otherwise>Domingo</c:otherwise>
                                                                </c:choose>
                                                            </td>

                                                            <td class="px-4 py-3 text-gray-600">
                                                                    ${slot.hourStart}
                                                            </td>

                                                            <td class="px-4 py-3 text-gray-600">
                                                                    ${slot.hourEnd}
                                                            </td>

                                                            <td class="px-4 py-3">

                                                            </td>

                                                        </tr>

                                                    </c:forEach>

                                                    </tbody>

                                                </table>

                                            </div>

                                        </c:otherwise>

                                    </c:choose>
                                </div>

                            <%-- Data e Hora --%>
                        <div class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                            <h3 class="text-sm font-bold text-gray-900 mb-4">Data e Hora</h3>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="inputData">Data</label>
                                    <input type="date" id="inputData"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="inputHora">Hora</label>
                                    <input type="time" id="inputHora"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                            </div>
                            <input type="hidden" name="dataHora" id="hiddenDataHora">
                            <span class="text-red-500 text-xs mt-1 block min-h-[1em]" id="erro-dataHora"></span>
                        </div>

                            <%-- Descrição --%>
                        <div class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                            <h3 class="text-sm font-bold text-gray-900 mb-4">Descrição da Sessão</h3>
                            <textarea name="descricao" id="descricao" rows="3"
                                      placeholder="Descreva o que será abordado na sessão..."
                                      class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full resize-y font-[inherit]"><c:out value="${descricao}"/></textarea>
                            <span class="text-red-500 text-xs mt-1 block min-h-[1em]" id="erro-descricao"></span>
                        </div>

                            <%-- Detalhes Online --%>
                        <div id="cardOnline" class="bg-white border border-gray-200 rounded-2xl px-6 py-5">
                            <h3 class="text-sm font-bold text-gray-900 mb-4">Detalhes Online</h3>
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="link">Link / Plataforma</label>
                                <input type="text" name="link" id="link"
                                       placeholder="Ex: https://meet.google.com/abc-defg"
                                       class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                <span class="text-red-500 text-xs mt-1 block min-h-[1em]" id="erro-link"></span>
                            </div>
                        </div>

                            <%-- Endereço Presencial --%>
                        <div id="cardPresencial" class="bg-white border border-gray-200 rounded-2xl px-6 py-5 hidden">
                            <h3 class="text-sm font-bold text-gray-900 mb-4">Endereço do Encontro</h3>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="cidade">Cidade *</label>
                                    <input type="text" name="cidade" id="cidade"
                                           placeholder="Ex: São Paulo"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="bairro">Bairro</label>
                                    <input type="text" name="bairro" id="bairro"
                                           placeholder="Ex: Centro"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="rua">Rua *</label>
                                    <input type="text" name="rua" id="rua"
                                           placeholder="Ex: Rua das Flores"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="numero">Número *</label>
                                    <input type="number" name="numero" id="numero"
                                           placeholder="Ex: 123" min="1"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                                <div class="flex flex-col gap-1.5 col-span-2">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="referencia">Ponto de Referência</label>
                                    <input type="text" name="referencia" id="referencia"
                                           placeholder="Ex: Próximo ao metrô"
                                           class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full">
                                </div>
                                <div class="flex flex-col gap-1.5 col-span-2">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide" for="instrucoes">Instruções Adicionais</label>
                                    <textarea name="instrucoes" id="instrucoes" rows="2"
                                              placeholder="Outras informações importantes..."
                                              class="px-3 py-2.5 border-2 border-gray-200 rounded-lg text-sm text-gray-900 outline-none focus:border-violet-600 focus:ring-2 focus:ring-violet-100 transition-all w-full resize-y font-[inherit]"></textarea>
                                </div>
                            </div>
                            <span class="text-red-500 text-xs mt-1 block min-h-[1em]" id="erro-presencial"></span>
                        </div>

                    </div><%-- /col-left --%>

                        <%-- ── RESUMO ── --%>
                    <div class="sticky top-6">
                        <div class="bg-white border border-gray-200 rounded-2xl p-6">
                            <h3 class="text-sm font-bold text-gray-900 mb-1">Resumo da Sessão</h3>
                            <p class="text-xs text-gray-400 mb-5">Revise os detalhes antes de confirmar</p>

                            <div class="flex flex-col gap-3 mb-5">
                                <div class="flex justify-between items-start gap-2 text-sm">
                                    <span class="text-gray-400 font-medium shrink-0">Professor</span>
                                    <span class="font-semibold text-gray-900 text-right break-words">${mentor.name}</span>
                                </div>
                                <div class="flex justify-between items-start gap-2 text-sm">
                                    <span class="text-gray-400 font-medium shrink-0">Tipo</span>
                                    <span class="font-semibold text-gray-900 text-right" id="resumoTipo">Online</span>
                                </div>
                                <div class="flex justify-between items-start gap-2 text-sm">
                                    <span class="text-gray-400 font-medium shrink-0">Interesse</span>
                                    <span class="font-semibold text-gray-900 text-right" id="resumoInteresse">—</span>
                                </div>
                                <div class="flex justify-between items-start gap-2 text-sm">
                                    <span class="text-gray-400 font-medium shrink-0">Data/Hora</span>
                                    <span class="font-semibold text-gray-900 text-right" id="resumoDataHora">—</span>
                                </div>
                            </div>

                                <%-- Seletor de Duração --%>
                            <div class="mb-5">
                                <p class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Duração</p>
                                <div class="grid grid-cols-3 gap-2" id="duracaoOptions">
                                    <button type="button"
                                            data-minutos="60" data-label="1h" data-custo="60"
                                            class="duracao-btn flex flex-col items-center py-2.5 px-1 rounded-xl border-2 border-violet-600 bg-violet-600 text-white font-semibold text-xs transition-all cursor-pointer selected">
                                        <span class="text-sm font-bold">1h</span>
                                        <span class="opacity-80">60 CS</span>
                                    </button>
                                    <button type="button"
                                            data-minutos="90" data-label="1h30" data-custo="90"
                                            class="duracao-btn flex flex-col items-center py-2.5 px-1 rounded-xl border-2 border-gray-200 text-gray-600 font-semibold text-xs transition-all cursor-pointer hover:border-violet-300">
                                        <span class="text-sm font-bold">1h30</span>
                                        <span class="opacity-80">90 CS</span>
                                    </button>
                                    <button type="button"
                                            data-minutos="120" data-label="2h" data-custo="120"
                                            class="duracao-btn flex flex-col items-center py-2.5 px-1 rounded-xl border-2 border-gray-200 text-gray-600 font-semibold text-xs transition-all cursor-pointer hover:border-violet-300">
                                        <span class="text-sm font-bold">2h</span>
                                        <span class="opacity-80">120 CS</span>
                                    </button>
                                </div>
                                <span class="text-red-500 text-xs mt-1 block min-h-[1em]" id="erro-duracao"></span>
                            </div>

                                <%-- Custo --%>
                            <div class="flex justify-between items-center text-sm border-t border-gray-100 pt-3 mb-5">
                                <span class="text-gray-500 font-medium">Custo</span>
                                <span class="font-bold text-violet-600 text-base" id="resumoCusto">60 CS</span>
                            </div>

                            <div class="bg-gray-50 border border-gray-200 rounded-xl p-3 text-xs text-gray-500 flex flex-col gap-1 mb-4">
                                <strong class="text-gray-700 text-sm">Proteção Aura</strong>
                                <span>Seu agendamento fica protegido até o professor confirmar.</span>
                            </div>

                            <button type="submit" id="btnConfirmar"
                                    class="w-full py-3.5 bg-violet-600 hover:bg-violet-700 text-white font-bold text-sm rounded-xl transition-colors font-[inherit] cursor-pointer">
                                Confirmar Agendamento
                            </button>
                            <span class="text-red-500 text-xs mt-2 block text-center min-h-[1em]" id="erro-geral"></span>
                        </div>
                    </div>

                </div><%-- /grid --%>
            </form>
        </c:otherwise>
    </c:choose>

</main>

<script src="${pageContext.request.contextPath}/assets/js/meetingRegister.js"></script>

</body>
</html>
