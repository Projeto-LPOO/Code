<%--
  Created by IntelliJ IDEA.
  User: jeovana
  Date: 05/05/2026
  Time: 22:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>WithDraw</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>
<body class="bg-white min-h-screen text-gray-800 flex flex-col">
<t:header paginaAtiva="financial" />

<div class="flex flex-1">
    <t:menu paginaAtiva="financial" />
        <main class="flex-1 flex items-center justify-center px-16">

            <div class="w-full max-w-2xl text-center">


                <div class="mb-10">
                    <h1 class="text-3xl font-semibold text-gray-900">
                        Quanto você deseja sacar?
                    </h1>
                    <p class="text-gray-500 mt-1">
                        Informe o valor em créditos
                    </p>
                </div>

                <!-- Form -->
                <form action="${pageContext.request.contextPath}/autenticado/financial/withdraw/details" method="post">

                    <!-- Valor -->
                    <div class="mb-4">
                        <input
                                type="text"
                                name="amount"
                                value="300"
                                inputmode="numeric"

                                onfocus="if(this.value==='300'){this.value=''}"
                                onblur="if(this.value === '' || parseInt(this.value) < 300){this.value='300'}"
                                oninput="this.value = this.value.replace(/[^0-9]/g, '')"

                                class="w-full text-center text-7xl font-bold bg-transparent border-0 border-b-2 border-gray-300 focus:border-purple-600 focus:outline-none tracking-wide"
                        />
                    </div>

                    <!-- Info -->
                    <div class="mb-8 space-y-1 text-gray-500">
                        <p>
                            Saldo disponível:
                            <span class="font-semibold text-gray-900">${account.getBalance()}</span>
                        </p>
                        <p class="text-sm">
                            Valor mínimo para saque: <span class="font-semibold">300 créditos</span>
                        </p>
                    </div>

                    <!-- Botão -->
                    <button
                            type="submit"
                            class="bg-purple-600 hover:bg-purple-700 text-white px-10 py-3 rounded-xl text-lg transition">
                        Continuar
                    </button>

                </form>

            </div>

        </main>
</html>
