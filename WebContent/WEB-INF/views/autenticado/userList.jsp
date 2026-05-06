<%@ page import="com.aura.user.models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuários</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/userList.css">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>
<body class="bg-white min-h-screen text-gray-800 flex flex-col"
      data-userid="<%= user.getId() %>"
      data-context="${pageContext.request.contextPath}">

<t:header paginaAtiva="financial" />

<div class="flex flex-1">
<t:menu paginaAtiva="explore"/>
<main class="flex-1 p-10 space-y-8">
    <input type="text" id="search-input" name="search" placeholder="O que você quer aprender hoje? (ex: 'React', 'Culinária', 'Piano')">

    <div class="cards" id="result"></div>
</main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/userList.js"></script>

</body>
</html>