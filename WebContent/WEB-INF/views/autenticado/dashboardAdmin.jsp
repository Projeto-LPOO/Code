<%@ page contentType="text/html;charset=UTF-8"
         language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="t"
           tagdir="/WEB-INF/tags" %>

<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard Administrativo</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>

<body class="bg-gray-50 min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="dashboard"/>

<div class="flex flex-1">

    <t:menuAdmin paginaAtiva="dashboard"/>

    <main class="flex-1 p-8 space-y-8 overflow-hidden">

        <!-- HEADER -->
        <section class="space-y-2">

            <h1 class="text-3xl font-bold text-gray-900">
                Dashboard Administrativo
            </h1>

            <p class="text-gray-500">
                Gerencie denúncias e evidências enviadas pelos usuários da plataforma.
            </p>

        </section>

        <!-- MÉTRICAS -->
        <section class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-6">

            <!-- TOTAL REPORTS -->
            <div class="
                bg-white
                border
                border-gray-200
                rounded-2xl
                p-6
                shadow-sm
            ">

                <p class="text-sm text-gray-500">
                    Total de denúncias
                </p>

                <h2 class="text-3xl font-bold text-[#8324a8] mt-3">
                    ${reportStats.totalReports}
                </h2>

                <p class="text-xs text-gray-400 mt-3">
                    Todas as denúncias registradas
                </p>

            </div>

            <!-- TOTAL EVIDÊNCIAS -->
            <div class="
                bg-white
                border
                border-gray-200
                rounded-2xl
                p-6
                shadow-sm
            ">

                <p class="text-sm text-gray-500">
                    Total de evidências
                </p>

                <h2 class="text-3xl font-bold text-indigo-600 mt-3">
                    ${reportStats.totalEvidences}
                </h2>

                <p class="text-xs text-gray-400 mt-3">
                    Evidências anexadas às denúncias
                </p>

            </div>

            <!-- PENDENTES -->
            <div class="
                bg-yellow-50
                border
                border-yellow-200
                rounded-2xl
                p-6
                shadow-sm
            ">

                <p class="text-sm text-yellow-700">
                    Pendentes
                </p>

                <h2 class="text-3xl font-bold text-yellow-600 mt-3">
                    ${reportStats.pendentes}
                </h2>

                <p class="text-xs text-yellow-700 mt-3">
                    Aguardando análise administrativa
                </p>

            </div>

            <!-- ACEITAS -->
            <div class="
                bg-green-50
                border
                border-green-200
                rounded-2xl
                p-6
                shadow-sm
            ">

                <p class="text-sm text-green-700">
                    Evidências aceitas
                </p>

                <h2 class="text-3xl font-bold text-green-600 mt-3">
                    ${reportStats.resolvidos}
                </h2>

                <p class="text-xs text-green-700 mt-3">
                    Evidências aprovadas
                </p>

            </div>

            <!-- RECUSADAS -->
            <div class="
                bg-red-50
                border
                border-red-200
                rounded-2xl
                p-6
                shadow-sm
            ">

                <p class="text-sm text-red-700">
                    Evidências recusadas
                </p>

                <h2 class="text-3xl font-bold text-red-600 mt-3">
                    ${reportStats.recusados}
                </h2>

                <p class="text-xs text-red-700 mt-3">
                    Evidências rejeitadas
                </p>

            </div>

        </section>

        <!-- TABELA -->
        <section class="
            bg-white
            border
            border-gray-200
            rounded-2xl
            shadow-sm
            overflow-hidden
        ">

            <!-- HEADER -->
            <div class="p-6 border-b border-gray-100">

                <div class="flex items-center justify-between">

                    <div>

                        <h2 class="text-xl font-semibold text-gray-900">
                            Denúncias registradas
                        </h2>

                        <p class="text-sm text-gray-500 mt-1">
                            Lista completa das denúncias realizadas pelos usuários
                        </p>

                    </div>

                </div>

            </div>

            <!-- TABLE -->
            <div class="overflow-x-auto">

                <table class="w-full min-w-[1200px]">

                    <thead class="bg-gray-50 border-b border-gray-100">

                    <tr class="text-left text-sm text-gray-600">

                        <th class="px-6 py-4 font-semibold">
                            ID
                        </th>

                        <th class="px-6 py-4 font-semibold">
                            Aluno
                        </th>

                        <th class="px-6 py-4 font-semibold">
                            Professor
                        </th>

                        <th class="px-6 py-4 font-semibold">
                            Reportado por
                        </th>

                        <th class="px-6 py-4 font-semibold">
                            Categoria
                        </th>

                        <th class="px-6 py-4 font-semibold">
                            Descrição
                        </th>

                    </tr>

                    </thead>

                    <tbody class="divide-y divide-gray-100">

                    <c:forEach items="${meetingReportList}"
                               var="report">

                        <tr class="hover:bg-gray-50 transition-colors">

                            <!-- ID -->
                            <td class="px-6 py-5 font-semibold text-gray-800">
                                #${report.id}
                            </td>

                            <!-- ALUNO -->
                            <td class="px-6 py-5">

                                <div class="space-y-1">

                                    <p class="font-medium text-gray-900">
                                            ${report.meetingReport.learner.name}
                                    </p>

                                    <p class="text-xs text-gray-400">
                                        Learner
                                    </p>

                                </div>

                            </td>

                            <!-- PROFESSOR -->
                            <td class="px-6 py-5">

                                <div class="space-y-1">

                                    <p class="font-medium text-gray-900">
                                            ${report.meetingReport.teacher.name}
                                    </p>

                                    <p class="text-xs text-gray-400">
                                        Teacher
                                    </p>

                                </div>

                            </td>

                            <!-- REPORTADO POR -->
                            <td class="px-6 py-5">

                                <div class="space-y-1">

                                    <p class="font-medium text-gray-900">
                                            ${report.fromUser.name}
                                    </p>

                                    <p class="text-xs text-gray-400">
                                        Usuário denunciante
                                    </p>

                                </div>

                            </td>
                            
                            <!-- CATEGORIA -->
                            <td class="px-6 py-5">

                                <span class="
                                    inline-flex
                                    items-center
                                    rounded-lg
                                    bg-gray-100
                                    text-gray-700
                                    px-3
                                    py-1
                                    text-xs
                                    font-medium
                                ">
                                        ${report.category}
                                </span>

                            </td>

                            <!-- DESCRIÇÃO -->
                            <td class="
                                px-6
                                py-5
                                max-w-lg
                                break-words
                            ">

                                <p class="text-sm text-gray-700 leading-relaxed">
                                        ${report.description}
                                </p>

                            </td>

                        </tr>

                    </c:forEach>

                    <!-- EMPTY STATE -->
                    <c:if test="${empty meetingReportList}">

                        <tr>

                            <td colspan="7"
                                class="px-6 py-16 text-center">

                                <div class="space-y-2">

                                    <h3 class="text-lg font-semibold text-gray-700">
                                        Nenhuma denúncia encontrada
                                    </h3>

                                    <p class="text-sm text-gray-500">
                                        Ainda não existem denúncias registradas na plataforma.
                                    </p>

                                </div>

                            </td>

                        </tr>

                    </c:if>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

</body>

</html>