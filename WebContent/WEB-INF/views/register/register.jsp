<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro</title>

    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="min-h-screen bg-gradient-to-br from-violet-100 via-white to-indigo-100 flex items-center justify-center p-6">

<div class="w-full max-w-lg bg-white rounded-2xl shadow-xl p-8">

    <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-800">Cadastro</h1>
        <p class="text-gray-500 mt-2">Crie sua conta para continuar</p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-6 p-4 rounded-lg border border-red-300 bg-red-100 text-red-700">
                ${error}
        </div>
    </c:if>

    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" class="space-y-5">

        <div>
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nome</label>
            <input id="name" name="name" type="text" value="${name}" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="Digite seu nome">
        </div>

        <div>
            <label for="age" class="block text-sm font-medium text-gray-700 mb-1">Idade</label>
            <input id="age" name="age" type="number" value="${age}" min="16" max="100" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="Digite sua idade">
        </div>

        <div>
            <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Endereço</label>
            <input id="address" name="address" type="text" value="${address}" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="Digite seu endereço">
        </div>

        <div>
            <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">Telefone</label>
            <input id="phone" name="phone" type="text" value="${phone}"
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="(99) 99999-9999">
        </div>

        <div>
            <label for="cpf" class="block text-sm font-medium text-gray-700 mb-1">CPF</label>
            <input id="cpf" name="cpf" type="text" value="${cpf}" maxlength="14" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="000.000.000-00">
        </div>

        <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">E-mail</label>
            <input id="email" name="email" type="email" value="${email}" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="email@exemplo.com">
        </div>

        <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Senha</label>
            <input id="password" name="password" type="password" minlength="6" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                   placeholder="Mínimo 6 caracteres">
        </div>

        <button type="submit"
                class="w-full bg-violet-600 hover:bg-violet-700 text-white font-semibold py-3 rounded-lg transition-colors">
            Cadastrar
        </button>

        <div class="text-center text-sm text-gray-600">
            Já possui uma conta?
            <a href="${pageContext.request.contextPath}/login" class="text-violet-600 hover:text-violet-800 font-semibold">
                Faça login
            </a>
        </div>

    </form>
</div>

<script>
    const cpfInput = document.getElementById("cpf");
    const phoneInput = document.getElementById("phone");

    cpfInput.addEventListener("input", e => {
        let value = e.target.value.replace(/\D/g, "");
        value = value.replace(/(\d{3})(\d)/, "$1.$2");
        value = value.replace(/(\d{3})(\d)/, "$1.$2");
        value = value.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
        e.target.value = value;
    });

    phoneInput.addEventListener("input", e => {
        let value = e.target.value.replace(/\D/g, "");

        if (value.length <= 10) {
            value = value.replace(/^(\d{2})(\d)/g, "($1) $2");
            value = value.replace(/(\d{4})(\d)/, "$1-$2");
        } else {
            value = value.replace(/^(\d{2})(\d)/g, "($1) $2");
            value = value.replace(/(\d{5})(\d)/, "$1-$2");
        }

        e.target.value = value;
    });
</script>

</body>
</html>