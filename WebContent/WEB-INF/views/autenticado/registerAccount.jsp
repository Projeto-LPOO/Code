<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>
<body class="bg-white min-h-screen text-gray-800 flex flex-col">
    <t:header paginaAtiva="financial" />
    <div class="flex flex-1">

    <t:menu paginaAtiva="financial" />
<main class="p-6 max-w-md mx-auto">>
    <h1>Cadastro de Dados Bancários</h1>
    <form action="${pageContext.request.contextPath}/autenticado/financial/saveaccount" method="post" class="flex flex-col gap-y-4">
        <input
                type="text"
                name="accountNumber"
                placeholder=" Número da conta"
                class="w-full h-10 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />

        <input
                type="text"
                name="bankName"
                placeholder=" Nome do banco"
                class="w-full h-10 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />

        <input
                type="text"
                name="ispb"
                placeholder=" ISPB"
                class="w-full h-10 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />

        <input
                type="text"
                name="pixKey"
                placeholder=" Chave PIX"
                class="w-full h-10 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />

        <input
                type="text"
                name="agency"
                placeholder=" Agência"
                class="w-full h-10 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />

        <input
                type="text"
                name="holderName"
                placeholder=" Nome do titular"
                class="w-full h-10 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />

        <button
                type="submit"
                class="w-full h-10 bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition"
        >
            Salvar conta
        </button>

    </form>

</main>
    </div>
</body>
</html>
