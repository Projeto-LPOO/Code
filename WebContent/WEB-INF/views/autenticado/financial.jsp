<%--
  Created by IntelliJ IDEA.
  User: jeovana
  Date: 01/05/2026
  Time: 15:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Carteira</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-white min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="financial" />

<div class="flex flex-1">

    <t:menu paginaAtiva="financial" />

    <main class="flex-1 p-10 space-y-8">

        <c:if test="${param.success == 'true'}">
            <div class="bg-green-100 border border-green-300 text-green-800 px-4 py-3 rounded-lg mb-4">
                Compra realizada com sucesso!
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="mb-4 px-4 py-3 rounded-lg border text-sm
            ${param.error == 'no_account' ? 'bg-yellow-100 text-yellow-800 border-yellow-300' : 'bg-red-100 text-red-800 border-red-300'}">

                <c:choose>
                    <c:when test="${param.error == 'invalid_package'}">
                        Pacote inválido.
                    </c:when>

                    <c:when test="${param.error == 'package_not_found'}">
                        Pacote não encontrado.
                    </c:when>

                    <c:when test="${param.error == 'payment_failed'}">
                        Falha no pagamento. Tente novamente.
                    </c:when>

                    <c:when test="${param.error == 'no_account'}">
                        Você precisa cadastrar uma conta bancária antes de comprar.
                    </c:when>

                    <c:otherwise>
                        Ocorreu um erro inesperado.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <div>
            <h1 class="text-2xl font-bold">Sua Carteira de Créditos</h1>
            <p class="text-gray-500 text-sm">
                Gerencie seus créditos e acompanhe seus ganhos
            </p>
        </div>

        <div class="grid grid-cols-3 gap-6">

            <div class="bg-gray-40 p-6 rounded-xl shadow-sm">
                <p class="text-sm text-gray-500">Saldo</p>
                <h2 class="text-3xl font-bold text-[#8324a8] mt-2">
                    ${credits.balance} cs
                </h2>
                <p class="text-xs text-gray-400 mt-2">
                    Créditos disponíveis para uso
                </p>
            </div>

            <div class="bg-gray-40 p-6 rounded-xl shadow-sm">
                <p class="text-sm text-gray-500">Entradas</p>
                <h2 class="text-xl font-semibold text-green-600 mt-2">
                    +${credits.totalEarned}
                </h2>
            </div>

            <div class="bg-gray-40 p-6 rounded-xl shadow-sm">
                <p class="text-sm text-gray-500">Saídas</p>
                <h2 class="text-xl font-semibold text-red-500 mt-2">
                    -${credits.totalSpent}
                </h2>
            </div>

        </div>
        <section class="max-w-6xl mx-auto py-12">

            <div class="mb-8">
                <h2 class="text-2xl font-semibold text-gray-800">Comprar créditos</h2>
                <p class="text-gray-500">
                    Recarregue sua carteira para começar a aprender com mentores experientes.
                </p>
            </div>

            <div class="grid md:grid-cols-3 gap-6">

                <c:forEach var="pkg" items="${packages}">

                    <c:set var="isPopular" value="${pkg.id == 2}" />

                    <div class="
        rounded-2xl p-6 text-center relative transition
        ${isPopular ? 'border-2 border-purple-600 bg-purple-50 shadow-md scale-105' : 'border shadow-sm'}
      ">
                        <c:if test="${isPopular}">
          <span class="absolute -top-3 left-1/2 -translate-x-1/2 bg-purple-600 text-white text-xs px-3 py-1 rounded-full">
            Mais Popular
          </span>
                        </c:if>

                        <h3 class="text-lg font-semibold text-gray-800 mb-2">
                                ${pkg.name}
                        </h3>

                        <p class="text-gray-500 text-sm mb-6">
                            <c:choose>
                                <c:when test="${pkg.credits <= 300}">
                                    Ideal para começar com algumas sessões.
                                </c:when>
                                <c:when test="${pkg.credits <= 700}">
                                    Ideal para aprendizado consistente com créditos extras.
                                </c:when>
                                <c:otherwise>
                                    Melhor custo-benefício para mentoria e crescimento a longo prazo.
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <p class="text-3xl font-bold text-gray-800">
                                ${pkg.credits} <span class="text-sm font-medium">CS</span>
                        </p>

                        <!-- Preço -->
                        <p class="text-purple-600 font-semibold text-lg mb-6">
                            $${pkg.price}
                        </p>

                        <!-- Botão -->
                        <form action="${pageContext.request.contextPath}/autenticado/financial/buycredits" method="post">
                            <input type="hidden" name="packageId" value="${pkg.id}" />

                            <button class="
                                w-full py-2 rounded-lg transition duration-200 ease-in-out
                                ${isPopular
                                  ? 'bg-purple-700 text-white hover:bg-purple-800 hover:scale-[1.02] active:scale-[0.98]'
                                  : 'border bg-white text-gray-800 hover:bg-gray-100 hover:border-gray-400 hover:scale-[1.02] active:scale-[0.98]'}
                                  ">
                                Compre agora
                            </button>
                        </form>

                    </div>

                </c:forEach>

            </div>

        </section>
        <div class="bg-gray-40 border rounded-xl p-6 flex justify-between items-center">
            <div>
                <p class="font-medium">Registrar conta bancária</p>
                <p class="text-sm text-gray-500">
                    Necessário para saques
                </p>
            </div>


            <a href="${pageContext.request.contextPath}/autenticado/financial/registerAccount"
               class="bg-black text-white px-4 py-2 rounded-lg hover:bg-gray-800">
                Registrar
            </a>
        </div>

    </main>
</div>



</body>
</html>