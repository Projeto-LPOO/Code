<%@ page import="com.aura.user.models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuários</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userList.css">
</head>

<body
        data-userid="${sessionScope.user.id}"
        data-context="${pageContext.request.contextPath}">

<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/users">Lista de usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>
    <header class="list-header">
        <h1>Listagem de Usuários</h1>
        <input type="text" id="search-input" placeholder="Encontre usuários">
    </header>

    <div class="cards" id="result">
        <p class="loading-msg">Buscando usuários...</p>
    </div>
</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/userList.js"></script>

</body>
</html>