<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ page import="com.aura.meeting.model.FaceToFaceMeeting" %>
<%@ page import="com.aura.meeting.model.OnlineMeeting" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User loggedUser = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Meetings | Infinity Aura</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/meetingRegister.css">
</head>

<body data-context="${pageContext.request.contextPath}">

<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Explorar</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/meeting" class="nav-active">Meetings</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>

    <div class="mr-page-header">
        <div>
            <h1 class="mr-page-title">Meus Meetings</h1>
            <p class="mr-page-sub">Visualize, edite ou cancele suas sessões agendadas.</p>
        </div>
        <a href="${pageContext.request.contextPath}/autenticado/users" class="mr-btn-primary">
            + Novo Meeting
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="mr-server-error">${error}</div>
    </c:if>

    <section>
        <c:choose>
            <c:when test="${empty meetings}">
                <div class="mr-empty-state">
                    <p class="mr-empty-title">Nenhum meeting cadastrado.</p>
                    <p class="mr-empty-text">Escolha um professor para começar.</p>
                    <a href="${pageContext.request.contextPath}/autenticado/users" class="mr-btn-primary">
                        Explorar Professores
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="m" items="${meetings}">
                    <div class="meeting-card">

                        <p><strong>Descrição:</strong> ${m.description}</p>
                        <p><strong>Data/Hora:</strong> ${m.dayTime}</p>
                        <p><strong>Status:</strong> ${m.status}</p>
                        <p><strong>Tipo:</strong> ${tipoMap[m.id]}</p>

                        <c:if test="${not empty m.category}">
                            <p><strong>Categoria:</strong> ${m.category.name}</p>
                        </c:if>

                        <button type="button"
                                class="btn-editar"
                                onclick="toggleEdit(this, '${m.id}', '${m.status}', '${tipoMap[m.id]}')">
                            Editar
                        </button>

                        <form action="${pageContext.request.contextPath}/autenticado/meeting/delete"
                              method="post"
                              style="display:inline;"
                              onsubmit="return confirm('Confirma exclusão?')">
                            <input type="hidden" name="id" value="${m.id}">
                            <button type="submit" class="btn-deletar">Deletar</button>
                        </form>

                        <div class="editPanel" style="display:none; margin-top:10px;">
                            <form action="${pageContext.request.contextPath}/autenticado/meeting/update"
                                  method="post"
                                  onsubmit="return validateEditForm(this, event)">
                                <input type="hidden" name="id" class="editId">

                                <label>Descrição:
                                    <input type="text" name="descricao" class="edit-descricao" required>
                                </label>
                                <span class="erro-campo edit-erro-descricao"></span><br>

                                <label>Data/Hora (dd/MM/yyyy HH:mm):
                                    <input type="text" name="dataHora" class="edit-dataHora"
                                           placeholder="25/12/2025 14:00">
                                </label>
                                <span class="erro-campo edit-erro-dataHora"></span><br>

                                <label>Status:
                                    <select name="status">
                                        <option value="pending">Pendente</option>
                                        <option value="confirmed">Confirmado</option>
                                        <option value="cancelled">Cancelado</option>
                                        <option value="done">Concluído</option>
                                    </select>
                                </label><br>

                                <div class="camposLocalizacao" style="display:none;">
                                    <label>Cidade:
                                        <input type="text" name="cidade" class="edit-cidade">
                                    </label>
                                    <span class="erro-campo edit-erro-cidade"></span><br>

                                    <label>Bairro:
                                        <input type="text" name="bairro">
                                    </label><br>

                                    <label>Rua:
                                        <input type="text" name="rua" class="edit-rua">
                                    </label>
                                    <span class="erro-campo edit-erro-rua"></span><br>

                                    <label>Número:
                                        <input type="number" name="numero" class="edit-numero">
                                    </label>
                                    <span class="erro-campo edit-erro-numero"></span><br>

                                    <label>Referência:
                                        <input type="text" name="referencia">
                                    </label><br>
                                </div>

                                <button type="submit">Salvar</button>
                                <button type="button"
                                        onclick="this.closest('.editPanel').style.display='none'">
                                    Cancelar
                                </button>
                            </form>
                        </div>

                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </section>

</main>

<style>
    .erro-campo   { color: red; font-size: 0.85em; }
    .meeting-card { border: 1px solid #E5E7EB; padding: 16px; margin-bottom: 16px; border-radius: 10px; background: #fff; }
    .btn-editar   { background: #7C3AED; color: #fff; border: none; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px; margin-right: 6px; }
    .btn-deletar  { background: #DC2626; color: #fff; border: none; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px; }
</style>

<script src="${pageContext.request.contextPath}/assets/js/meetingList.js"></script>

</body>
</html>