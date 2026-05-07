<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastrar Meeting</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/meeting.css">
</head>

<body data-context="${pageContext.request.contextPath}">

<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/meeting">Meetings</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>
    <h1>Cadastrar Meeting</h1>

    <c:if test="${not empty error}">
        <p class="erro-campo server-error">${error}</p>
    </c:if>

    <span id="preselected-teacher-id"
          data-value="${not empty preselectedTeacherId ? preselectedTeacherId : ''}"
          style="display:none;"></span>

    <form id="formCadastro"
          action="${pageContext.request.contextPath}/autenticado/meeting/register"
          method="post">

        <label>Tipo:
            <select name="tipo" id="tipoSelectCadastro">
                <option value="online"     ${tipo == 'online'     ? 'selected' : ''}>Online</option>
                <option value="presencial" ${tipo == 'presencial' ? 'selected' : ''}>Presencial</option>
            </select>
        </label><br>

        <label>Descrição:
            <input type="text" name="descricao" id="descricao" value="${descricao}">
        </label>
        <span class="erro-campo" id="erro-descricao"></span><br>

        <label>Data/Hora (dd/MM/yyyy HH:mm):
            <input type="text" name="dataHora" id="dataHora" value="${dataHora}" placeholder="25/12/2025 14:00">
        </label>
        <span class="erro-campo" id="erro-dataHora"></span><br>

        <div id="cadastroOnline">
            <label>Link/Plataforma:
                <input type="text" name="link" id="link">
            </label>
            <span class="erro-campo" id="erro-link"></span><br>
        </div>

        <div id="cadastroPresencial" style="display:none;">
            <label>Cidade: <input type="text" name="cidade" id="cidade"></label>
            <span class="erro-campo" id="erro-cidade"></span><br>
            <label>Bairro: <input type="text" name="bairro" id="bairro"></label><br>
            <label>Rua: <input type="text" name="rua" id="rua"></label>
            <span class="erro-campo" id="erro-rua"></span><br>
            <label>Número: <input type="number" name="numero" id="numero"></label>
            <span class="erro-campo" id="erro-numero"></span><br>
            <label>Ponto de referência: <input type="text" name="referencia" id="referencia"></label><br>
            <label>Instruções (opcional): <input type="text" name="instrucoes" id="instrucoes"></label><br>
        </div>

        <fieldset id="mentorSection" style="margin-top:12px;">
            <legend>Professor</legend>

            <c:choose>
                <c:when test="${not empty mentor}">
                    <p id="mentorName">
                        <strong>${mentor.name}</strong>
                        <a href="${pageContext.request.contextPath}/autenticado/users"
                           style="font-size:0.85em; margin-left:8px;">Trocar</a>
                    </p>
                    <input type="hidden" name="teacherId" id="teacherId" value="${mentor.id}">
                </c:when>
                <c:otherwise>
                    <p class="erro-campo">
                        Nenhum professor selecionado.
                        <a href="${pageContext.request.contextPath}/autenticado/users">Selecionar na lista de usuários</a>
                    </p>
                    <input type="hidden" name="teacherId" id="teacherId" value="">
                </c:otherwise>
            </c:choose>
            <span class="erro-campo" id="erro-professor"></span>
        </fieldset>

        <fieldset id="categorySection" style="margin-top:12px;">
            <legend>Habilidade do Professor</legend>

            <label>Categoria:
                <select id="selectCategoria" name="categoriaId">
                    <option value="">-- Selecione --</option>
                </select>
            </label><br>

            <label>Conhecimento (Interesse):
                <select id="selectInteresse" name="interestId" disabled>
                    <option value="">-- Selecione a categoria primeiro --</option>
                </select>
            </label>
            <input type="hidden" name="interestId" id="interestIdHidden">
            <br>
        </fieldset>

        <br>
        <button type="submit" id="submitBtn">Cadastrar</button>
        <a href="${pageContext.request.contextPath}/autenticado/meeting">← Voltar</a>
        <p class="erro-campo" id="erro-geral"></p>
    </form>
</main>

<style>
    .erro-campo { color: red; font-size: 0.85em; }
    .server-error { font-weight: bold; margin-bottom: 10px; }
</style>

<script src="${pageContext.request.contextPath}/assets/js/meetingRegister.js"></script>

</body>
</html>