<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<html>
<head>
    <title>Dados Bancários</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-white min-h-screen text-gray-800 flex flex-col">
<t:header paginaAtiva="financial" />

<div class="flex flex-1">
    <t:menu paginaAtiva="financial" />

    <main class="flex-1 px-14 py-12">
        <div class="max-w-3xl">

            <div class="mb-8">
                <div class="flex items-center gap-3 mb-1">
                    <div class="w-8 h-8 rounded-lg bg-purple-100 flex items-center justify-center">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="text-purple-600">
                            <rect x="2" y="5" width="20" height="14" rx="2" stroke="currentColor" stroke-width="2"/>
                            <path d="M2 10h20" stroke="currentColor" stroke-width="2"/>
                            <path d="M6 15h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>
                    <h1 class="text-lg font-semibold text-gray-800">Dados Bancários</h1>
                </div>
                <p class="text-sm text-gray-400 ml-11">Preencha os dados da conta para recebimento</p>
            </div>

            <form action="${pageContext.request.contextPath}/autenticado/financial/saveaccount" method="post" class="flex flex-col gap-4">


                <div class="flex gap-3">
                    <div class="flex-1 flex flex-col gap-1">
                        <label class="text-xs font-medium text-gray-500 ml-1">Número da conta</label>
                        <input
                                type="text"
                                name="accountNumber"
                                placeholder="00000-0"
                                class="w-full h-10 px-3 py-2 text-sm border border-gray-200 rounded-lg bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-400 focus:border-transparent focus:bg-white transition"
                        />
                    </div>
                    <div class="w-32 flex flex-col gap-1">
                        <label class="text-xs font-medium text-gray-500 ml-1">Agência</label>
                        <input
                                type="text"
                                name="agency"
                                placeholder="0000"
                                class="w-full h-10 px-3 py-2 text-sm border border-gray-200 rounded-lg bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-400 focus:border-transparent focus:bg-white transition"
                        />
                    </div>
                </div>


                <div class="flex flex-col gap-1">
                    <label class="text-xs font-medium text-gray-500 ml-1">Nome do banco</label>
                    <input
                            type="text"
                            name="bankName"
                            placeholder="Ex: Nubank, Itaú, Bradesco..."
                            class="w-full h-10 px-3 py-2 text-sm border border-gray-200 rounded-lg bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-400 focus:border-transparent focus:bg-white transition"
                    />
                </div>


                <div class="flex flex-col gap-1">
                    <label class="text-xs font-medium text-gray-500 ml-1">ISPB</label>
                    <input
                            type="text"
                            name="ispb"
                            placeholder="00000000"
                            class="w-full h-10 px-3 py-2 text-sm border border-gray-200 rounded-lg bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-400 focus:border-transparent focus:bg-white transition"
                    />
                </div>


                <div class="flex flex-col gap-1">
                    <label class="text-xs font-medium text-gray-500 ml-1">Chave PIX</label>
                    <input
                            type="text"
                            name="pixKey"
                            placeholder="CPF, e-mail, telefone ou chave aleatória"
                            class="w-full h-10 px-3 py-2 text-sm border border-gray-200 rounded-lg bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-400 focus:border-transparent focus:bg-white transition"
                    />
                </div>


                <div class="flex flex-col gap-1">
                    <label class="text-xs font-medium text-gray-500 ml-1">Nome do titular</label>
                    <input
                            type="text"
                            name="holderName"
                            placeholder="Nome completo"
                            class="w-full h-10 px-3 py-2 text-sm border border-gray-200 rounded-lg bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-400 focus:border-transparent focus:bg-white transition"
                    />
                </div>


                <div class="border-t border-gray-100 my-1"></div>


                <button
                        type="submit"
                        class="w-full h-10 bg-purple-600 text-white text-sm font-medium rounded-lg hover:bg-purple-700 active:scale-95 transition-all"
                >
                    Salvar conta
                </button>

            </form>
        </div>
    </main>
</div>
</body>
</html>