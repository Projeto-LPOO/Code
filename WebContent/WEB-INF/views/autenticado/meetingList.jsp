<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ page import="com.aura.meeting.model.FaceToFaceMeeting" %>
<%@ page import="com.aura.meeting.model.OnlineMeeting" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%
    User loggedUser = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Meetings | Infinity Aura</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-white min-h-screen" data-context="${pageContext.request.contextPath}">

<t:header paginaAtiva="meetings" />

<div class="flex flex-1">

    <t:menu paginaAtiva="meetings" />

    <main class="flex-1 p-10">

        <div class="flex items-center justify-between mb-7">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Meus Meetings</h1>
                <p class="text-sm text-gray-500 mt-1">Gerencie suas sessões de aprendizado e ensino.</p>
            </div>
            <a href="${pageContext.request.contextPath}/autenticado/users"
               class="inline-block bg-violet-600 hover:bg-violet-700 text-white font-semibold text-sm px-5 py-2.5 rounded-xl transition-colors">
                + Novo Meeting
            </a>
        </div>

        <c:if test="${not empty statusError}">
            <div class="bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm mb-5">${statusError}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm mb-5">${error}</div>
        </c:if>

        <%-- aviso de balanço --%>
        <%
            String balanceWarning = (String) session.getAttribute("balanceWarning");
            if (balanceWarning != null) {
                session.removeAttribute("balanceWarning");
        %>
        <div class="bg-amber-50 border border-amber-300 text-amber-800 rounded-xl px-4 py-3 text-sm mb-5 flex items-start gap-2">
            <span class="text-lg leading-none">⚠</span>
            <span><%= balanceWarning %></span>
        </div>
        <% } %>

        <%-- display de balanço --%>
        <c:if test="${not empty userCreditsBalance}">
            <div class="inline-flex items-center gap-2 bg-violet-50 border border-violet-200 text-violet-700 rounded-xl px-4 py-2 text-sm font-semibold mb-5">
                 Seu saldo: <span class="font-bold">${userCreditsBalance} CS</span>
            </div>
        </c:if>

        <%-- abas de navegação --%>
        <div class="flex gap-0 border-b border-gray-200 mb-6">
            <button onclick="showTab('pendentes')" id="tab-pendentes"
                    class="tab-btn px-5 py-2.5 text-sm font-semibold border-b-2 border-violet-600 text-violet-700 -mb-px transition-colors">
                Pendentes
            </button>
            <button onclick="showTab('confirmados')" id="tab-confirmados"
                    class="tab-btn px-5 py-2.5 text-sm font-semibold border-b-2 border-transparent text-gray-500 -mb-px hover:text-gray-700 transition-colors">
                Confirmados
            </button>
            <button onclick="showTab('cancelados')" id="tab-cancelados"
                    class="tab-btn px-5 py-2.5 text-sm font-semibold border-b-2 border-transparent text-gray-500 -mb-px hover:text-gray-700 transition-colors">
                Cancelados
            </button>
            <button onclick="showTab('concluidos')" id="tab-concluidos"
                    class="tab-btn px-5 py-2.5 text-sm font-semibold border-b-2 border-transparent text-gray-500 -mb-px hover:text-gray-700 transition-colors">
                Concluídos
            </button>
        </div>

        <%-- aba pendentes --%>
        <div id="pane-pendentes" class="tab-pane">
            <c:set var="hasPending" value="false" />
            <c:forEach var="m" items="${meetings}">
                <c:if test="${m.status == 'pending'}">
                    <c:set var="hasPending" value="true" />
                </c:if>
            </c:forEach>

            <c:choose>
                <c:when test="${hasPending == 'false'}">
                    <div class="bg-white border border-gray-200 rounded-2xl p-12 text-center">
                        <p class="text-sm font-semibold text-gray-600">Nenhum meeting pendente.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <section class="flex flex-col gap-4">
                        <c:forEach var="m" items="${meetings}">
                            <c:if test="${m.status == 'pending'}">
                                <div class="bg-white border border-gray-200 rounded-2xl p-5 meeting-card">

                                    <div class="flex items-start justify-between gap-4 mb-3">
                                        <div class="flex flex-col gap-1">
                                            <p class="text-sm font-semibold text-gray-900">${m.description}</p>
                                            <p class="text-xs text-gray-500">${m.dayTime}</p>
                                        </div>
                                        <div class="flex items-center gap-2 shrink-0">
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full
                                                ${tipoMap[m.id] == 'ONLINE' ? 'bg-blue-50 text-blue-700' : 'bg-amber-50 text-amber-700'}">
                                                    ${tipoMap[m.id]}
                                            </span>
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-yellow-50 text-yellow-700">
                                                Pendente
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${not empty m.category}">
                                        <p class="text-xs text-gray-400 mb-1">Categoria: <span class="font-medium text-gray-600">${m.category.name}</span></p>
                                    </c:if>

                                    <p class="text-xs text-gray-400 mb-1">
                                        Professor: <span class="font-medium text-gray-600">${m.teacher.name}</span>
                                    </p>
                                    <p class="text-xs text-gray-400 mb-3">
                                        Aluno: <span class="font-medium text-gray-600">${m.learner.name}</span>
                                    </p>

                                    <c:if test="${m.durationMinutes > 0}">
                                        <p class="text-xs text-gray-400 mb-3">
                                            Duração: <span class="font-medium text-gray-600">
                                                <c:choose>
                                                    <c:when test="${m.durationMinutes == 60}">1h (60 CS)</c:when>
                                                    <c:when test="${m.durationMinutes == 90}">1h30 (90 CS)</c:when>
                                                    <c:when test="${m.durationMinutes == 120}">2h (120 CS)</c:when>
                                                    <c:otherwise>${m.durationMinutes} min</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </p>
                                    </c:if>

                                    <p class="text-xs mb-3">
                                        <span class="font-semibold px-2 py-0.5 rounded-full
                                            ${m.userRole == 'TEACHER' ? 'bg-violet-100 text-violet-700' : 'bg-sky-100 text-sky-700'}">
                                                ${m.userRole == 'TEACHER' ? 'Você é o professor' : 'Você é o aluno'}
                                        </span>
                                    </p>

                                    <div class="flex items-center gap-2 mt-3 flex-wrap">
                                        <c:if test="${m.userRole == 'TEACHER'}">
                                            <form action="${pageContext.request.contextPath}/autenticado/meeting/status" method="post" class="inline">
                                                <input type="hidden" name="id" value="${m.id}">
                                                <input type="hidden" name="status" value="confirmed">
                                                <button type="submit"
                                                        class="bg-green-600 hover:bg-green-700 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                                    Confirmar
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/autenticado/meeting/status" method="post" class="inline"
                                                  onsubmit="return confirmarCancelamento(${cancelDeadlineMap[m.id]}, '${m.userRole}')">
                                                <input type="hidden" name="id" value="${m.id}">
                                                <input type="hidden" name="status" value="cancelled">
                                                <button type="submit"
                                                        class="bg-red-500 hover:bg-red-600 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                                    Recusar
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${m.userRole == 'LEARNER'}">
                                            <p class="text-xs text-gray-400 italic">Aguardando confirmação do professor.</p>
                                        </c:if>
                                    </div>

                                </div>
                            </c:if>
                        </c:forEach>
                    </section>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- aba confirmados --%>
        <div id="pane-confirmados" class="tab-pane hidden">
            <c:set var="hasConfirmed" value="false" />
            <c:forEach var="m" items="${meetings}">
                <c:if test="${m.status == 'confirmed'}">
                    <c:set var="hasConfirmed" value="true" />
                </c:if>
            </c:forEach>

            <c:choose>
                <c:when test="${hasConfirmed == 'false'}">
                    <div class="bg-white border border-gray-200 rounded-2xl p-12 text-center">
                        <p class="text-sm font-semibold text-gray-600">Nenhum meeting confirmado.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <section class="flex flex-col gap-4">
                        <c:forEach var="m" items="${meetings}">
                            <c:if test="${m.status == 'confirmed'}">
                                <div class="bg-white border border-gray-200 rounded-2xl p-5 meeting-card">

                                    <div class="flex items-start justify-between gap-4 mb-3">
                                        <div class="flex flex-col gap-1">
                                            <p class="text-sm font-semibold text-gray-900">${m.description}</p>
                                            <p class="text-xs text-gray-500">${m.dayTime}</p>
                                        </div>
                                        <div class="flex items-center gap-2 shrink-0">
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full
                                                ${tipoMap[m.id] == 'ONLINE' ? 'bg-blue-50 text-blue-700' : 'bg-amber-50 text-amber-700'}">
                                                    ${tipoMap[m.id]}
                                            </span>
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-green-50 text-green-700">
                                                Confirmado
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${not empty m.category}">
                                        <p class="text-xs text-gray-400 mb-1">Categoria: <span class="font-medium text-gray-600">${m.category.name}</span></p>
                                    </c:if>

                                    <p class="text-xs text-gray-400 mb-1">
                                        Professor: <span class="font-medium text-gray-600">${m.teacher.name}</span>
                                    </p>
                                    <p class="text-xs text-gray-400 mb-3">
                                        Aluno: <span class="font-medium text-gray-600">${m.learner.name}</span>
                                    </p>

                                    <c:if test="${m.durationMinutes > 0}">
                                        <p class="text-xs text-gray-400 mb-3">
                                            Duração: <span class="font-medium text-gray-600">
                                                <c:choose>
                                                    <c:when test="${m.durationMinutes == 60}">1h (60 CS)</c:when>
                                                    <c:when test="${m.durationMinutes == 90}">1h30 (90 CS)</c:when>
                                                    <c:when test="${m.durationMinutes == 120}">2h (120 CS)</c:when>
                                                    <c:otherwise>${m.durationMinutes} min</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </p>
                                    </c:if>

                                    <p class="text-xs mb-3">
                                        <span class="font-semibold px-2 py-0.5 rounded-full
                                            ${m.userRole == 'TEACHER' ? 'bg-violet-100 text-violet-700' : 'bg-sky-100 text-sky-700'}">
                                                ${m.userRole == 'TEACHER' ? 'Você é o professor' : 'Você é o aluno'}
                                        </span>
                                    </p>

                                    <div class="flex items-center gap-2 mt-3 flex-wrap">
                                        <c:if test="${m.userRole == 'TEACHER'}">
                                            <form action="${pageContext.request.contextPath}/autenticado/meeting/status" method="post"
                                                  onsubmit="return confirm('Marcar este meeting como concluído?')" class="inline">
                                                <input type="hidden" name="id" value="${m.id}">
                                                <input type="hidden" name="status" value="done">
                                                <button type="submit"
                                                        class="bg-violet-600 hover:bg-violet-700 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                                    Marcar como Concluído
                                                </button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/autenticado/meeting/status" method="post" class="inline"
                                              onsubmit="return confirmarCancelamento(${cancelDeadlineMap[m.id]}, '${m.userRole}')">
                                            <input type="hidden" name="id" value="${m.id}">
                                            <input type="hidden" name="status" value="cancelled">
                                            <button type="submit"
                                                    class="bg-red-500 hover:bg-red-600 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                                Cancelar
                                            </button>
                                        </form>
                                    </div>

                                </div>
                            </c:if>
                        </c:forEach>
                    </section>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- aba cancelados --%>
        <div id="pane-cancelados" class="tab-pane hidden">
            <c:set var="hasCancelled" value="false" />
            <c:forEach var="m" items="${meetings}">
                <c:if test="${m.status == 'cancelled'}">
                    <c:set var="hasCancelled" value="true" />
                </c:if>
            </c:forEach>

            <c:choose>
                <c:when test="${hasCancelled == 'false'}">
                    <div class="bg-white border border-gray-200 rounded-2xl p-12 text-center">
                        <p class="text-sm font-semibold text-gray-600">Nenhum meeting cancelado.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <section class="flex flex-col gap-4">
                        <c:forEach var="m" items="${meetings}">
                            <c:if test="${m.status == 'cancelled'}">
                                <div class="bg-white border border-gray-200 rounded-2xl p-5">

                                    <div class="flex items-start justify-between gap-4 mb-3">
                                        <div class="flex flex-col gap-1">
                                            <p class="text-sm font-semibold text-gray-900">${m.description}</p>
                                            <p class="text-xs text-gray-500">${m.dayTime}</p>
                                        </div>
                                        <div class="flex items-center gap-2 shrink-0">
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full
                                                ${tipoMap[m.id] == 'ONLINE' ? 'bg-blue-50 text-blue-700' : 'bg-amber-50 text-amber-700'}">
                                                    ${tipoMap[m.id]}
                                            </span>
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-red-50 text-red-600">
                                                Cancelado
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${not empty m.category}">
                                        <p class="text-xs text-gray-400 mb-1">Categoria: <span class="font-medium text-gray-600">${m.category.name}</span></p>
                                    </c:if>

                                    <p class="text-xs text-gray-400 mb-1">
                                        Professor: <span class="font-medium text-gray-600">${m.teacher.name}</span>
                                    </p>
                                    <p class="text-xs text-gray-400 mb-3">
                                        Aluno: <span class="font-medium text-gray-600">${m.learner.name}</span>
                                    </p>

                                    <p class="text-xs mb-3">
                                        <span class="font-semibold px-2 py-0.5 rounded-full
                                            ${m.userRole == 'TEACHER' ? 'bg-violet-100 text-violet-700' : 'bg-sky-100 text-sky-700'}">
                                                ${m.userRole == 'TEACHER' ? 'Você era o professor' : 'Você era o aluno'}
                                        </span>
                                    </p>

                                </div>
                            </c:if>
                        </c:forEach>
                    </section>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- aba concluídos --%>
        <div id="pane-concluidos" class="tab-pane hidden">
            <c:set var="hasDone" value="false" />
            <c:forEach var="m" items="${meetings}">
                <c:if test="${m.status == 'done' || m.status == 'reported'}">
                    <c:set var="hasDone" value="true" />
                </c:if>
            </c:forEach>

            <c:choose>
                <c:when test="${hasDone == 'false'}">
                    <div class="bg-white border border-gray-200 rounded-2xl p-12 text-center">
                        <p class="text-sm font-semibold text-gray-600">Nenhum meeting concluído ainda.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <section class="flex flex-col gap-4">
                        <c:forEach var="m" items="${meetings}">
                            <c:if test="${m.status == 'done' || m.status == 'reported'}">
                                <div class="bg-white border border-gray-200 rounded-2xl p-5">

                                    <div class="flex items-start justify-between gap-4 mb-3">
                                        <div class="flex flex-col gap-1">
                                            <p class="text-sm font-semibold text-gray-900">${m.description}</p>
                                            <p class="text-xs text-gray-500">${m.dayTime}</p>
                                        </div>
                                        <div class="flex items-center gap-2 shrink-0">
                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full
                                                ${tipoMap[m.id] == 'ONLINE' ? 'bg-blue-50 text-blue-700' : 'bg-amber-50 text-amber-700'}">
                                                    ${tipoMap[m.id]}
                                            </span>
                                            <c:choose>
                                                <c:when test="${m.status == 'reported'}">
                                                    <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-orange-50 text-orange-700">
                                                        Reportado
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-gray-100 text-gray-600">
                                                        Concluído
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <c:if test="${not empty m.category}">
                                        <p class="text-xs text-gray-400 mb-1">Categoria: <span class="font-medium text-gray-600">${m.category.name}</span></p>
                                    </c:if>

                                    <p class="text-xs text-gray-400 mb-1">
                                        Professor: <span class="font-medium text-gray-600">${m.teacher.name}</span>
                                    </p>
                                    <p class="text-xs text-gray-400 mb-3">
                                        Aluno: <span class="font-medium text-gray-600">${m.learner.name}</span>
                                    </p>

                                    <p class="text-xs mb-3">
                                        <span class="font-semibold px-2 py-0.5 rounded-full
                                            ${m.userRole == 'TEACHER' ? 'bg-violet-100 text-violet-700' : 'bg-sky-100 text-sky-700'}">
                                                ${m.userRole == 'TEACHER' ? 'Você foi o professor' : 'Você foi o aluno'}
                                        </span>
                                    </p>

                                    <div class="flex items-center gap-2 mt-3 flex-wrap">

                                        <c:choose>
                                            <c:when test="${m.status == 'reported'}">
                                                <span class="inline-flex items-center gap-1 text-xs font-semibold text-orange-700 bg-orange-50 px-3 py-1.5 rounded-lg">
                                                    ⚠ Meeting reportado
                                                </span>
                                            </c:when>
                                            <c:when test="${feedbackDoneMap[m.id]}">
                                                <span class="inline-flex items-center gap-1 text-xs font-semibold text-green-700 bg-green-50 px-3 py-1.5 rounded-lg">
                                                    ✓ Avaliação enviada
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/autenticado/feedback?meetingId=${m.id}"
                                                   class="inline-block bg-violet-600 hover:bg-violet-700 text-white text-xs font-semibold px-4 py-1.5 rounded-lg transition-colors">
                                                        ${m.userRole == 'TEACHER' ? '⭐ Avaliar Aluno' : '⭐ Avaliar Professor'}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${reportDoneMap[m.id]}">
                                                <span class="inline-flex items-center gap-1 text-xs font-semibold text-gray-500 bg-gray-100 px-3 py-1.5 rounded-lg">
                                                    ✓ Report enviado
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/autenticado/meeting/report?meetingId=${m.id}"
                                                   class="inline-block bg-red-50 hover:bg-red-100 text-red-600 border border-red-200 text-xs font-semibold px-4 py-1.5 rounded-lg transition-colors">
                                                    ⚑ Reportar
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>

                                </div>
                            </c:if>
                        </c:forEach>
                    </section>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/meetingList.js"></script>
<script>
    function confirmarCancelamento(comReembolso, papel) {
        if (comReembolso) {
            return confirm('Cancelar este meeting? Os créditos serão devolvidos.');
        }
        // fora do prazo de 3 dias
        if (papel === 'TEACHER') {
            return confirm('Cancelar este meeting?\n\nAtenção: o meeting está a menos de 3 dias de acontecer. O cancelamento será realizado, mas os créditos do aluno não serão reembolsados.');
        }
        return confirm('Cancelar este meeting?\n\nAtenção: o meeting está a menos de 3 dias de acontecer. O cancelamento será realizado, mas seus créditos não serão reembolsados.');
    }
</script>

</body>
</html>