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
        <p style="color:red;">${error}</p>
    </c:if>

    <form id="formCadastro"
          action="${pageContext.request.contextPath}/autenticado/meeting/register"
          method="post"
          onsubmit="return validarCadastro(event)">

        <label>Tipo:
            <select name="tipo" id="tipoSelectCadastro" onchange="toggleCadastro()">
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

        <!-- Campos Online -->
        <div id="cadastroOnline">
            <label>Link/Plataforma:
                <input type="text" name="link" id="link">
            </label>
            <span class="erro-campo" id="erro-link"></span><br>
        </div>

        <!-- Campos Presencial -->
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

        <!-- Seletor de Usuário -->
        <fieldset style="margin-top:12px;">
            <legend>Selecionar Usuário (opcional por ora)</legend>

            <input type="text" id="buscaUsuario"
                   placeholder="Digite o nome do usuário..."
                   autocomplete="off">

            <div id="resultadoUsuarios"
                 style="border:1px solid #ccc; max-height:180px; overflow-y:auto; display:none;"></div>

            <p id="usuarioSelecionadoLabel" style="display:none;">
                Selecionado: <strong id="usuarioSelecionadoNome"></strong>
                <button type="button" onclick="limparUsuario()">✕</button>
            </p>

            <input type="hidden" name="usuarioId" id="usuarioId">
        </fieldset>

        <br>
        <button type="submit">Cadastrar</button>
        <a href="${pageContext.request.contextPath}/autenticado/meeting">← Voltar</a>
        <p class="erro-campo" id="erro-geral"></p>
    </form>
</main>

<style>
    .erro-campo { color: red; font-size: 0.85em; }
</style>

<script src="${pageContext.request.contextPath}/assets/js/meeting.js"></script>

</body>
</html>