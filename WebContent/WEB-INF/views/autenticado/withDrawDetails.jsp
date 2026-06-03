<%--
  Created by IntelliJ IDEA.
  User: jeovana
  Date: 06/05/2026
  Time: 14:45
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
        <main class="flex-1 px-14 py-12">

            <div class="max-w-3xl">

                <div class="mb-10">
                    <h1 class="text-3xl font-bold text-[#6b21a8]">
                        Confirmar saque
                    </h1>

                    <p class="text-gray-500 mt-2">
                        Revise os dados antes de continuar.
                    </p>
                </div>

                <div class="space-y-6 text-base">

                    <div class="flex items-center justify-between border-b border-gray-200 pb-4">
                    <span class="text-gray-500">
                        Titular
                    </span>

                        <span class="font-semibold">
                            ${account.getHolderName()}
                        </span>
                    </div>

                    <div class="flex items-center justify-between border-b border-gray-200 pb-4">
                    <span class="text-gray-500">
                        Banco
                    </span>

                        <span class="font-semibold">
                            ${account.getBankName()}
                        </span>
                    </div>

                    <div class="flex items-center justify-between border-b border-gray-200 pb-4">
                    <span class="text-gray-500">
                        Número da conta
                    </span>

                        <span class="font-semibold">
                            ${account.getAccountNumber()}
                        </span>
                    </div>

                    <div class="flex items-center justify-between border-b border-gray-200 pb-4">
                    <span class="text-gray-500">
                        Agência
                    </span>

                        <span class="font-semibold">
                            ${account.getAgency()}
                        </span>
                    </div>

                    <div class="flex items-center justify-between border-b border-gray-200 pb-4">
                    <span class="text-gray-500">
                        Créditos debitados
                    </span>

                        <span class="font-semibold text-red-500">
                        - ${amount}
                    </span>
                    </div>

                    <div class="flex items-center justify-between pt-2">
                    <span class="text-lg font-medium">
                        Valor em reais
                    </span>

                        <span class="text-3xl font-bold text-green-600">
                        R$ ${amountMoney}
                    </span>
                    </div>

                </div>

                <form action="${pageContext.request.contextPath}/autenticado/financial/withdraw/confirm"
                      method="post"
                      class="mt-12 flex gap-4">

                    <button type="submit"
                            class="bg-[#6b21a8] hover:bg-[#581c87] transition text-white font-medium px-8 py-3 rounded-xl cursor-pointer">
                        Confirmar saque
                    </button>

                    <a href="${pageContext.request.contextPath}/autenticado/financial"
                       class="border border-gray-300 hover:bg-gray-100 transition px-8 py-3 rounded-xl font-medium">
                        Cancelar
                    </a>
                    <input type="hidden" name="amountMoney" value="${amountMoney}">
                    <input type="hidden" name="amount" value="${amount}">
                </form>

            </div>

        </main>
</html>
