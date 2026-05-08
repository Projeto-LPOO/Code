<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de login</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>
<body>
<% User user = (User) session.getAttribute("user"); %>
<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/meeting">Meeting</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>
<body class="bg-white min-h-screen text-gray-800 flex flex-col">
<t:header paginaAtiva="financial" />

<div class="flex flex-1">
    <t:menu paginaAtiva="dashboard" />
<main  class="flex-1 p-10 space-y-8">
    <h1 class="text-2xl font-bold text-gray-800 mb-1">
        Bem-vindo, ${user.name}
    </h1>
    <p class="text-sm text-gray-500">
        Pronto para aprimorar suas habilidades ou compartilhar sua experiência hoje?
    </p>
</main>
</div>
</body>
</html>