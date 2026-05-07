<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.Models.User" %>
<%@ page import="com.aura.interest.Interest" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
</head>
<body>
<%User user = (User) session.getAttribute("user");%>
<%List<Interest> interests = (List<Interest>) request.getAttribute("interests");%>

<main>
<%
    for(Interest intr : interests)
    {
        out.write(intr.getName() + " - ");
        out.write(intr.getDescription());
    }
%>

</main>
</body>
</html>