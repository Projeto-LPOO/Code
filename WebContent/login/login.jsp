<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/login/login.css">
</head>
<body>
<h1>Login</h1>
    <form action="" method="post">
        Email: <input type="text" name="email"/>
        Senha: <input type="password" name="password"/>
        <input type="submit" value="Enviar"/>
    </form>
    <a href="${pageContext.request.contextPath}/register">Criar conta</a>
</body>
</html>