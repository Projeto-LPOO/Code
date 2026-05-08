<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuários</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-white min-h-screen text-gray-800 flex flex-col"
      data-userid="${sessionScope.user.id}"
      data-context="${pageContext.request.contextPath}">

<t:header paginaAtiva="explorer" />

<div class="flex flex-1">

    <t:menu paginaAtiva="explorer" />

    <main class="flex-1 p-10 space-y-8">

        <div class="max-w-7xl mx-auto">

            <!-- HEADER -->
            <div class="mb-8">

                <h1 class="text-[28px] font-semibold text-slate-800 mb-5">
                    Listagem de Usuários
                </h1>

                <input type="text"
                       id="search-input"
                       placeholder="Encontre usuários"

                       class="w-full max-w-[350px]
                              px-4 py-3
                              text-sm
                              bg-slate-50
                              border border-slate-200
                              rounded-xl
                              outline-none
                              shadow-[0_2px_6px_rgba(0,0,0,0.05)]
                              transition-all
                              focus:border-indigo-500
                              focus:bg-white
                              focus:ring-4
                              focus:ring-indigo-200">

            </div>

            <!-- RESULTADOS -->
            <div id="result"
                 class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5 w-full items-start">

                <p class="text-slate-400 text-sm">
                    Buscando usuários...
                </p>

            </div>

        </div>

    </main>

</div>

<script src="${pageContext.request.contextPath}/assets/js/userList.js"></script>

</body>
</html>