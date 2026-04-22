<%@ page import="com.aura.user.Models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuários</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/UserList.css">

</head>
<body>
<% User user = (User) session.getAttribute("user"); %>

<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home.jsp">Dashboard</a></li>
            <a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuarios</a>
            <a href="${pageContext.request.contextPath}/logout">Sair</a>
        </ul>
    </nav>
</aside>

<main>
    <h1>Listagem de Usuários</h1>
    <input type="text" id="search-input" name="search" placeholder="Encontre usuários" oninput="search()">
    <div class="cards" id="result"></div>
</main>

<script>
    const loggedUserId = <%= user.getId() %>;

    function search() {
        const term = document.getElementById("search-input").value;
        const url = term
            ? "<%= request.getContextPath() %>/autenticado/searchUsers?name=" + term
            : "<%= request.getContextPath() %>/autenticado/searchUsers?name=";

        fetch(url)
            .then(response => response.json())
            .then(data => {
                console.log(data);
                const result = document.getElementById("result");
                result.innerHTML = "";

                if (data.length === 0) {
                    result.innerHTML = "<p>Nenhum usuário encontrado</p>";
                    return;
                }
                data.forEach(user_ => {
                    console.log(user_);
                    if (user_.id != loggedUserId) {
                        result.innerHTML +=
                            "<div class='user-card'>" +
                            "<p>Name: " + user_.name + "</p>" +
                            "<p>Age: " + user_.age + "</p>" +
                            "<p>Address: " + user_.address + "</p>" +
                            "</div>";
                    }
                });
            })
            .catch(error => {
                console.error("Erro:", error);
            });
    }
    window.onload = function() {
        search();
    };
</script>
</body>
</html>