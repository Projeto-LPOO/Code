<%@ page import="com.aura.user.models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Suas Skills</title>
</head>
<body>
<main>

    <h1>Quais são suas Habilidades?</h1>

    <form action="${pageContext.request.contextPath}/autenticado/interest/skills" method="post">

        <c:forEach var="category" items="${categories}">
            <h2>${category.name}</h2>

            <c:forEach var="inter" items="${interestsByCategory[category.id]}">
                <label>
                    <input type="checkbox" name="interests" value="${inter.id}">
                        ${inter.name}
                </label>
                <br/>
            </c:forEach>

            <br/>
        </c:forEach>

        <button type="submit">Salvar interesses</button>

    </form>
</main>
</body>
</html>