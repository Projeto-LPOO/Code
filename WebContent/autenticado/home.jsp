<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.Models.User" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
</head>
<body>
<%User user = (User) session.getAttribute("user");%>
<main>
    <section class="card-bv">
        <h1>Bem-vindo, ${user.name}</h1>
    </section>
</main>
</body>
</html>