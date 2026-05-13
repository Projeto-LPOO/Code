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

    <%-- Cabeçalho --%>
    <div class="flex items-center justify-between mb-7">
        <div>
            <h1 class="text-2xl font-bold text-gray-900">Meus Meetings</h1>
            <p class="text-sm text-gray-500 mt-1">Visualize, edite ou cancele suas sessões agendadas.</p>
        </div>
        <a href="${pageContext.request.contextPath}/autenticado/users"
           class="inline-block bg-violet-600 hover:bg-violet-700 text-white font-semibold text-sm px-5 py-2.5 rounded-xl transition-colors">
            + Novo Meeting
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm mb-5">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty meetings}">
            <div class="bg-white border border-gray-200 rounded-2xl p-16 text-center">
                <p class="text-base font-semibold text-gray-700 mb-2">Nenhum meeting cadastrado.</p>
                <p class="text-sm text-gray-400 mb-6">Escolha um professor para começar.</p>
                <a href="${pageContext.request.contextPath}/autenticado/users"
                   class="inline-block bg-violet-600 hover:bg-violet-700 text-white font-semibold text-sm px-6 py-2.5 rounded-xl transition-colors">
                    Explorar Professores
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <section class="flex flex-col gap-4">
                <c:forEach var="m" items="${meetings}">
                    <div class="bg-white border border-gray-200 rounded-2xl p-5 meeting-card">

                            <%-- Info topo --%>
                        <div class="flex items-start justify-between gap-4 mb-3">
                            <div class="flex flex-col gap-1">
                                <p class="text-sm font-semibold text-gray-900">${m.description}</p>
                                <p class="text-xs text-gray-500">${m.dayTime}</p>
                            </div>
                            <div class="flex items-center gap-2 shrink-0">
                                    <%-- Badge tipo --%>
                                <span class="text-xs font-semibold px-2.5 py-1 rounded-full
                                    ${tipoMap[m.id] == 'ONLINE'
                                        ? 'bg-blue-50 text-blue-700'
                                        : 'bg-amber-50 text-amber-700'}">
                                        ${tipoMap[m.id]}
                                </span>
                                    <%-- Badge status --%>
                                <span class="text-xs font-semibold px-2.5 py-1 rounded-full
                                    ${m.status == 'pending'   ? 'bg-yellow-50 text-yellow-700' :
                                      m.status == 'confirmed' ? 'bg-green-50  text-green-700'  :
                                      m.status == 'cancelled' ? 'bg-red-50    text-red-600'    :
                                      m.status == 'done'      ? 'bg-gray-100  text-gray-600'   :
                                                                 'bg-gray-100  text-gray-600'}">
                                        ${m.status}
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty m.category}">
                            <p class="text-xs text-gray-400 mb-3">
                                Categoria: <span class="font-medium text-gray-600">${m.category.name}</span>
                            </p>
                        </c:if>

                            <%-- Duração --%>
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

                            <%-- Ações --%>
                        <div class="flex items-center gap-2 mt-3">
                            <button type="button"
                                    class="bg-violet-600 hover:bg-violet-700 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors"
                                    onclick="toggleEdit(this, '${m.id}', '${m.status}', '${tipoMap[m.id]}')">
                                Editar
                            </button>
                            <form action="${pageContext.request.contextPath}/autenticado/meeting/delete"
                                  method="post"
                                  onsubmit="return confirm('Confirma exclusão?')"
                                  class="inline">
                                <input type="hidden" name="id" value="${m.id}">
                                <button type="submit"
                                        class="bg-red-500 hover:bg-red-600 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                    Deletar
                                </button>
                            </form>
                        </div>

                            <%-- Painel de edição --%>
                        <div class="editPanel hidden mt-4 border-t border-gray-100 pt-4">
                            <form action="${pageContext.request.contextPath}/autenticado/meeting/update"
                                  method="post"
                                  onsubmit="return validateEditForm(this, event)"
                                  class="flex flex-col gap-3">
                                <input type="hidden" name="id" class="editId">

                                <div class="flex flex-col gap-1">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Descrição</label>
                                    <input type="text" name="descricao" class="edit-descricao px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full" required>
                                    <span class="text-red-500 text-xs edit-erro-descricao"></span>
                                </div>

                                <div class="flex flex-col gap-1">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Data/Hora (dd/MM/yyyy HH:mm)</label>
                                    <input type="text" name="dataHora" class="edit-dataHora px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full" placeholder="25/12/2025 14:00">
                                    <span class="text-red-500 text-xs edit-erro-dataHora"></span>
                                </div>

                                <div class="flex flex-col gap-1">
                                    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Status</label>
                                    <select name="status" class="px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full bg-white">
                                        <option value="pending">Pendente</option>
                                        <option value="confirmed">Confirmado</option>
                                        <option value="cancelled">Cancelado</option>
                                        <option value="done">Concluído</option>
                                    </select>
                                </div>

                                <div class="camposLocalizacao hidden flex flex-col gap-3">
                                    <div class="flex flex-col gap-1">
                                        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Cidade</label>
                                        <input type="text" name="cidade" class="edit-cidade px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full">
                                        <span class="text-red-500 text-xs edit-erro-cidade"></span>
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Bairro</label>
                                        <input type="text" name="bairro" class="px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full">
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Rua</label>
                                        <input type="text" name="rua" class="edit-rua px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full">
                                        <span class="text-red-500 text-xs edit-erro-rua"></span>
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Número</label>
                                        <input type="number" name="numero" class="edit-numero px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full">
                                        <span class="text-red-500 text-xs edit-erro-numero"></span>
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Referência</label>
                                        <input type="text" name="referencia" class="px-3 py-2 border-2 border-gray-200 rounded-lg text-sm outline-none focus:border-violet-600 w-full">
                                    </div>
                                </div>

                                <div class="flex gap-2 mt-1">
                                    <button type="submit"
                                            class="bg-violet-600 hover:bg-violet-700 text-white text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                        Salvar
                                    </button>
                                    <button type="button"
                                            onclick="this.closest('.editPanel').classList.add('hidden')"
                                            class="bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-semibold px-4 py-1.5 rounded-lg cursor-pointer transition-colors">
                                        Cancelar
                                    </button>
                                </div>
                            </form>
                        </div>

                    </div>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>

</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/meetingList.js"></script>

</body>
</html>
