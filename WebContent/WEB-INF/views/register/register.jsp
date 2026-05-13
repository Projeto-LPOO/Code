<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Cadastro de Usuário</title>
</head>
<body>

<main>
    <h1>Cadastro</h1>

    <form action="${pageContext.request.contextPath}/register" method="post">

        <label>Nome:</label><br/>
        <input type="text" name="name" required />
        <br/><br/>

        <label>Idade:</label><br/>
        <input type="number" name="age" min="16" max="100" required />
        <br/><br/>

        <label>Endereço:</label><br/>
        <input type="text" name="address" required />
        <br/><br/>

        <label>Telefone:</label><br/>
        <input type="text" name="phone" />
        <br/><br/>

        <label>CPF:</label><br/>
        <input type="text" name="cpf" required />
        <br/><br/>

        <label>Email:</label><br/>
        <input type="email" name="email" required />
        <br/><br/>

        <label>Senha:</label><br/>
        <input type="password" name="password" minlength="6" required />
        <br/><br/>

        <button type="submit">Cadastrar</button>
    </form>
    <li><a href="${pageContext.request.contextPath}/login">Faça login</a></li>
</main>

</body>
</html>