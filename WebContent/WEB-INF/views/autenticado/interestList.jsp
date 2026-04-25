<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aura.interest.model.Interest" %>
<%@ page import="com.aura.category.Category" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Lista de Interesses</title>
</head>
<body>
<main>
    <c:forEach var="category" items="${categories}">
        <h2>${category.name}</h2>

        <c:forEach var="inter" items="${interestsByCategory[category.id]}">
            <input type="checkbox" value="${inter.id}"> <p>${inter.name}</p>
        </c:forEach>

        <br/><br/>
    </c:forEach>
</main>

</body>
</html>
