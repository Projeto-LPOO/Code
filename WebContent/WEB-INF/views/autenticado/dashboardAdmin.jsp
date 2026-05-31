<%@ page contentType="text/html;charset=UTF-8"
         language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="t"
           tagdir="/WEB-INF/tags" %>

<html>

<head>

    <title>Dashboard Admin</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>

<body class="bg-white min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="dashboard" />

<div class="flex flex-1">

    <t:menuAdmin paginaAtiva="dashboard" />

    <main class="flex-1 p-10 space-y-8">

        <!-- HEADER -->
        <div>

            <h1 class="text-3xl font-bold">
                Dashboard Administrativo
            </h1>

            <p class="text-gray-500 text-sm mt-1">
                Gerencie reportações realizadas pelos usuários
            </p>

        </div>

        <!-- MÉTRICAS -->
        <div class="grid grid-cols-4 gap-6">

            <!-- TOTAL -->
            <div class="bg-[#ededed] p-6 rounded-xl shadow-sm">

                <p class="text-sm text-gray-500">
                    Total de reportações
                </p>

                <h2 class="text-3xl font-bold text-[#8324a8] mt-2">
                    ${reportStats.total}
                </h2>

                <p class="text-xs text-gray-400 mt-2">
                    Todas as denúncias registradas
                </p>

            </div>

            <!-- PENDENTES -->
            <div class="border p-6 rounded-xl shadow-sm bg-yellow-50 border-yellow-200">

                <p class="text-sm text-yellow-700">
                    Pendentes
                </p>

                <h2 class="text-3xl font-bold text-yellow-600 mt-2">
                    ${reportStats.pendentes}
                </h2>

                <p class="text-xs text-yellow-700 mt-2">
                    Aguardando análise
                </p>

            </div>

            <!-- EM ANÁLISE -->
            <div class="border p-6 rounded-xl shadow-sm bg-blue-50 border-blue-200">

                <p class="text-sm text-blue-700">
                    Em análise
                </p>

                <h2 class="text-3xl font-bold text-blue-600 mt-2">
                    ${reportStats.emAnalise}
                </h2>

                <p class="text-xs text-blue-700 mt-2">
                    Casos sendo avaliados
                </p>

            </div>

            <!-- RESOLVIDOS -->
            <div class="border p-6 rounded-xl shadow-sm bg-green-50 border-green-200">

                <p class="text-sm text-green-700">
                    Resolvidos
                </p>

                <h2 class="text-3xl font-bold text-green-600 mt-2">
                    ${reportStats.resolvidos}
                </h2>

                <p class="text-xs text-green-700 mt-2">
                    Casos concluídos
                </p>

            </div>

        </div>

        <!-- TABELA -->
        <section class="border rounded-2xl overflow-hidden shadow-sm bg-white">

            <!-- HEADER DA TABELA -->
            <div class="p-6 border-b">

                <h2 class="text-xl font-semibold">
                    Meetings reportados
                </h2>

                <p class="text-sm text-gray-500 mt-1">
                    Lista completa de denúncias registradas na plataforma
                </p>

            </div>

            <!-- TABLE -->
            <div class="overflow-x-auto">

                <table class="w-full">

                    <thead class="bg-gray-50">

                    <tr class="text-left text-gray-600 text-sm">

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
                            Status
                        </th>

                        <th class="px-6 py-4 font-semibold">
                            Motivo
                        </th>

                    </tr>

                    </thead>

                    <tbody class="divide-y divide-gray-100">

                    <c:forEach items="${meetingReportList}"
                               var="report">

                        <tr class="hover:bg-gray-50 transition">

                            <!-- ID -->
                            <td class="px-6 py-5 font-semibold text-gray-800">
                                #${report.id}
                            </td>

                            <!-- ALUNO -->
                            <td class="px-6 py-5">

                                <div>

                                    <p class="font-medium">
                                            ${report.meetingReport.learner.name}
                                    </p>

                                    <p class="text-xs text-gray-400">
                                        Learner
                                    </p>

                                </div>

                            </td>

                            <!-- PROFESSOR -->
                            <td class="px-6 py-5">

                                <div>

                                    <p class="font-medium">
                                            ${report.meetingReport.teacher.name}
                                    </p>

                                    <p class="text-xs text-gray-400">
                                        Teacher
                                    </p>

                                </div>

                            </td>

                            <!-- REPORTADO POR -->
                            <td class="px-6 py-5">

                                <div>

                                    <p class="font-medium">
                                            ${report.fromUser.name}
                                    </p>

                                    <p class="text-xs text-gray-400">
                                        Usuário denunciante
                                    </p>

                                </div>

                            </td>

                            <!-- STATUS -->
                            <td class="px-6 py-5">

                                <c:choose>

                                    <c:when test="${report.status == 'PENDENTE'}">

                                        <span class="
                                            inline-flex
                                            items-center
                                            px-3
                                            py-1
                                            rounded-full
                                            text-xs
                                            font-medium
                                            bg-yellow-100
                                            text-yellow-700
                                        ">
                                            Pendente
                                        </span>

                                    </c:when>

                                    <c:when test="${report.status == 'EM_ANALISE'}">

                                        <span class="
                                            inline-flex
                                            items-center
                                            px-3
                                            py-1
                                            rounded-full
                                            text-xs
                                            font-medium
                                            bg-blue-100
                                            text-blue-700
                                        ">
                                            Em análise
                                        </span>

                                    </c:when>

                                    <c:when test="${report.status == 'RESOLVIDO'}">

                                        <span class="
                                            inline-flex
                                            items-center
                                            px-3
                                            py-1
                                            rounded-full
                                            text-xs
                                            font-medium
                                            bg-green-100
                                            text-green-700
                                        ">
                                            Resolvido
                                        </span>

                                    </c:when>

                                </c:choose>

                            </td>

                            <!-- MOTIVO -->
                            <td class="px-6 py-5">

                                <div class="max-w-md">

                                    <span class="
                                        inline-block
                                        bg-red-100
                                        text-red-700
                                        text-xs
                                        px-3
                                        py-1
                                        rounded-full
                                        mb-2
                                    ">
                                        Reportação
                                    </span>

                                    <p class="text-sm text-gray-700 leading-relaxed">
                                            ${report.reason}
                                    </p>

                                </div>

                            </td>

                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

</body>

</html>
```
