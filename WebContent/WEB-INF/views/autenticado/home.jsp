<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/shared/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/home.css">
</head>
<body>
<% User user = (User) session.getAttribute("user"); %>
<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/agenda">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>
        <h1>Bem-vindo, ${user.name}</h1>
</main>
</body>
</html>