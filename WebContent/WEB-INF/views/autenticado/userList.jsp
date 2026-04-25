<%@ page import="com.aura.user.models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuários</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/shared/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/userList/userList.css">
</head>

<body
        data-userid="<%= user.getId() %>"
        data-context="${pageContext.request.contextPath}">

<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>
    <h1>Listagem de Usuários</h1>

    <input type="text" id="search-input" name="search" placeholder="Encontre usuários">

    <div class="cards" id="result"></div>
</main>

<script src="${pageContext.request.contextPath}/assets/userList/userList.js"></script>

</body>
</html>