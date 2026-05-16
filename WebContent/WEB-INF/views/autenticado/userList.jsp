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

        <div class="mb-10 flex flex-col gap-5">

            <!-- título -->
            <div class="space-y-2">

        <span class="inline-flex items-center gap-2
                     px-3 py-1
                     rounded-full
                     bg-indigo-50
                     text-indigo-600
                     text-xs
                     font-semibold
                     border border-indigo-100">

            Explorer
        </span>

                <h1 class="text-3xl font-bold tracking-tight text-slate-800">
                    Listagem de Usuários
                </h1>

                <p class="text-sm text-slate-500 max-w-xl leading-relaxed">
                    Explore usuários da plataforma, encontre interesses em comum
                    e descubra novos perfis rapidamente.
                </p>

            </div>

            <!-- search -->
            <div class="relative w-full max-w-[420px]">

                <svg xmlns="http://www.w3.org/2000/svg"
                     fill="none"
                     viewBox="0 0 24 24"
                     stroke-width="1.8"
                     stroke="currentColor"
                     class="w-5 h-5 absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">

                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          d="m21 21-4.35-4.35m0 0A7.65 7.65 0 1 0 5.85 5.85a7.65 7.65 0 0 0 10.8 10.8Z" />

                </svg>

                <input type="text"
                       id="search-input"
                       placeholder="Pesquisar usuários..."

                       class="w-full
                      pl-12 pr-4 py-3.5
                      rounded-2xl
                      border border-slate-200
                      bg-white/90
                      backdrop-blur
                      text-sm text-slate-700
                      shadow-sm
                      outline-none
                      transition-all duration-300
                      placeholder:text-slate-400
                      hover:border-slate-300
                      hover:shadow-md
                      focus:border-indigo-500
                      focus:ring-4
                      focus:ring-indigo-100
                      focus:shadow-[0_8px_30px_rgba(99,102,241,0.15)]">

            </div>

        </div>

        <!-- RESULTADOS -->
        <div id="result"
             class="grid
            grid-cols-1
            sm:grid-cols-2
            xl:grid-cols-3
            2xl:grid-cols-4
            gap-6
            items-start">

            <p class="text-sm text-slate-400">
                Buscando usuários...
            </p>

        </div>

    </main>

</div>

<script src="${pageContext.request.contextPath}/assets/js/userList.js"></script>

</body>
</html>