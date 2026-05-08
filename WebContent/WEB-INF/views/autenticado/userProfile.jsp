<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>${user.name} | Infinity Aura</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>

<body class="bg-[#f5f7fb] min-h-screen text-slate-800 flex flex-col">

<t:header paginaAtiva="financial"/>

<div class="flex flex-1">

    <t:menu paginaAtiva="financial"/>

    <main class="w-full flex justify-center px-4 sm:px-6 lg:px-8 py-10 lg:ml-[240px]">

        <div class="w-full max-w-6xl flex flex-col gap-6">

            <c:if test="${empty user}">

                <div class="min-h-[60vh] flex flex-col items-center justify-center gap-5">

                    <svg class="w-[70px] h-[70px] opacity-30"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.5"
                         viewBox="0 0 24 24">

                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>

                    </svg>

                    <h2 class="text-3xl font-black">
                        Usuário não encontrado
                    </h2>

                    <a href="${pageContext.request.contextPath}/autenticado/users"
                       class="text-violet-700 font-semibold hover:underline">

                        Voltar

                    </a>

                </div>

            </c:if>

            <c:if test="${not empty user}">

                <!-- BREADCRUMB -->
                <nav class="flex items-center gap-2 text-sm text-slate-400">

                    <a href="${pageContext.request.contextPath}/autenticado/users"
                       class="hover:text-slate-600 transition">

                        Usuários

                    </a>

                    <span>/</span>

                    <span class="text-slate-600 font-semibold">
                            ${user.name}
                    </span>

                </nav>

                <!-- PROFILE -->
                <section class="bg-white rounded-[28px]
                                overflow-hidden
                                border border-slate-200
                                shadow-[0_8px_24px_rgba(15,23,42,0.06)]">

                    <!-- BANNER -->
                    <div class="h-[170px]
                                bg-gradient-to-br
                                from-violet-800
                                via-violet-600
                                to-indigo-600">

                    </div>

                    <div class="relative px-5 sm:px-7 lg:px-9 pb-9">

                        <!-- AVATAR -->
                        <div class="w-[110px] h-[110px]
                                    rounded-[28px]
                                    bg-gradient-to-br
                                    from-violet-600
                                    to-violet-800
                                    border-[6px] border-white
                                    flex items-center justify-center
                                    text-white text-5xl font-black
                                    shadow-[0_12px_30px_rgba(109,40,217,0.30)]
                                    -mt-[55px]
                                    relative z-20">

                                ${user.name.substring(0,1).toUpperCase()}

                        </div>

                        <!-- HEADER -->
                        <div class="mt-6">

                            <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">

                                <!-- ESQUERDA -->
                                <div>

                                    <h1 class="text-3xl sm:text-4xl font-black">
                                            ${user.name}
                                    </h1>

                                    <p class="mt-2 text-slate-500">
                                        Principal Software Architect
                                    </p>

                                </div>

                                <!-- DIREITA -->
                                <a href="${pageContext.request.contextPath}/autenticado/schedule"
                                   class="inline-flex items-center justify-center
                                          bg-gradient-to-br
                                          from-violet-600
                                          to-violet-800
                                          text-white
                                          px-7 py-3.5
                                          rounded-2xl
                                          font-bold
                                          whitespace-nowrap
                                          shadow-[0_10px_24px_rgba(109,40,217,0.22)]
                                          hover:-translate-y-0.5
                                          transition">

                                    Agendar Sessão

                                </a>

                            </div>

                        </div>

                        <!-- STATS -->
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-5 mt-9">

                            <!-- CARD -->
                            <div class="bg-[#fafbff]
                                        border border-[#edf0f7]
                                        rounded-3xl
                                        p-6
                                        text-center">

                                <div class="w-[52px] h-[52px]
                                            mx-auto mb-4
                                            rounded-2xl
                                            bg-violet-100
                                            text-violet-700
                                            flex items-center justify-center">

                                    <svg class="w-6 h-6"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         viewBox="0 0 24 24">

                                        <circle cx="12" cy="12" r="10"/>
                                        <path d="M12 6v6l4 2"/>

                                    </svg>

                                </div>

                                <h3 class="text-3xl font-black">
                                    482
                                </h3>

                                <span class="text-slate-500 text-sm">
                                    Horas Ensinadas
                                </span>

                            </div>

                            <!-- CARD -->
                            <div class="bg-[#fafbff]
                                        border border-[#edf0f7]
                                        rounded-3xl
                                        p-6
                                        text-center">

                                <div class="w-[52px] h-[52px]
                                            mx-auto mb-4
                                            rounded-2xl
                                            bg-violet-100
                                            text-violet-700
                                            flex items-center justify-center">

                                    <svg class="w-6 h-6"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         viewBox="0 0 24 24">

                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                        <circle cx="9" cy="7" r="4"/>

                                    </svg>

                                </div>

                                <h3 class="text-3xl font-black">
                                    124
                                </h3>

                                <span class="text-slate-500 text-sm">
                                    Aprendizes Ativos
                                </span>

                            </div>

                            <!-- CARD -->
                            <div class="bg-[#fafbff]
                                        border border-[#edf0f7]
                                        rounded-3xl
                                        p-6
                                        text-center">

                                <div class="w-[52px] h-[52px]
                                            mx-auto mb-4
                                            rounded-2xl
                                            bg-violet-100
                                            text-violet-700
                                            flex items-center justify-center">

                                    <svg class="w-6 h-6"
                                         fill="currentColor"
                                         viewBox="0 0 20 20">

                                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>

                                    </svg>

                                </div>

                                <h3 class="text-3xl font-black">
                                    4.9
                                </h3>

                                <span class="text-slate-500 text-sm">
                                    Avaliação Média
                                </span>

                            </div>

                        </div>

                    </div>

                </section>

                <!-- JORNADA -->
                <section class="bg-white border border-slate-200 rounded-3xl p-7 shadow-[0_8px_24px_rgba(15,23,42,0.06)]">

                    <div class="flex items-center gap-3 mb-5">

                        <div class="w-7 h-7 rounded-xl
                                    bg-gradient-to-br
                                    from-violet-600
                                    to-violet-800
                                    text-white
                                    flex items-center justify-center
                                    text-xs">

                            ✦

                        </div>

                        <h2 class="text-xl font-black">
                            Minha Jornada
                        </h2>

                    </div>

                    <p class="text-slate-500 leading-8">

                        Aqui serão evidenciadas as experiências, trajetória,
                        projetos, conhecimentos e evolução profissional do usuário
                        dentro da plataforma Infinity Aura.

                    </p>

                </section>

                <!-- INTERESSES -->
                <section class="bg-white border border-slate-200 rounded-3xl p-7 shadow-[0_8px_24px_rgba(15,23,42,0.06)]">

                    <div class="flex items-center gap-3 mb-5">

                        <div class="w-7 h-7 rounded-xl
                                    bg-gradient-to-br
                                    from-violet-600
                                    to-violet-800
                                    text-white
                                    flex items-center justify-center
                                    text-xs">

                            ✦

                        </div>

                        <h2 class="text-xl font-black">
                            Interesses & Habilidades
                        </h2>

                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

                        <c:forEach items="${user.interests}" var="interest">

                            <div class="bg-[#fafbff]
                                        border border-[#edf0f7]
                                        rounded-2xl
                                        p-5
                                        hover:border-violet-300
                                        hover:-translate-y-0.5
                                        transition">

                                <h3 class="font-bold mb-1">
                                        ${interest.name}
                                </h3>

                                <p class="text-sm text-slate-500">

                                    <c:choose>

                                        <c:when test="${not empty interest.category}">
                                            ${interest.category.name}
                                        </c:when>

                                        <c:otherwise>
                                            Interesse
                                        </c:otherwise>

                                    </c:choose>

                                </p>

                            </div>

                        </c:forEach>

                    </div>

                </section>

                <!-- INFORMAÇÕES -->
                <section class="bg-white border border-slate-200 rounded-3xl p-7 shadow-[0_8px_24px_rgba(15,23,42,0.06)]">

                    <div class="flex items-center gap-3 mb-5">

                        <div class="w-7 h-7 rounded-xl
                                    bg-gradient-to-br
                                    from-violet-600
                                    to-violet-800
                                    text-white
                                    flex items-center justify-center
                                    text-xs">

                            ✦

                        </div>

                        <h2 class="text-xl font-black">
                            Informações Pessoais
                        </h2>

                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">

                        <div class="bg-[#fafbff] border border-[#edf0f7] rounded-2xl p-5">

                            <span class="block text-xs font-bold tracking-widest text-slate-400 mb-2">
                                IDADE
                            </span>

                            <strong class="text-slate-700">
                                    ${user.age} anos
                            </strong>

                        </div>

                        <div class="bg-[#fafbff] border border-[#edf0f7] rounded-2xl p-5">

                            <span class="block text-xs font-bold tracking-widest text-slate-400 mb-2">
                                TELEFONE
                            </span>

                            <strong class="text-slate-700">
                                    ${user.phone}
                            </strong>

                        </div>

                        <div class="bg-[#fafbff] border border-[#edf0f7] rounded-2xl p-5 lg:col-span-2">

                            <span class="block text-xs font-bold tracking-widest text-slate-400 mb-2">
                                ENDEREÇO
                            </span>

                            <strong class="text-slate-700">
                                    ${user.address}
                            </strong>

                        </div>

                    </div>

                </section>

            </c:if>

        </div>

    </main>

</div>

<footer class="text-center py-6 text-sm text-slate-400 lg:ml-[240px]">
    © 2026 Aura. Conectando pessoas pelo conhecimento.
</footer>

<script src="${pageContext.request.contextPath}/assets/js/userProfile.js"></script>

</body>
</html>