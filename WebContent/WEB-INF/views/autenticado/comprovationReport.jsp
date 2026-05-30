<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <title>Enviar Comprovação</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>

<body class="bg-slate-50 min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="meetings" />

<div class="flex flex-1">

    <t:menu paginaAtiva="meetings" />

    <main class="flex-1 p-10 min-w-0">

        <!-- HEADER -->
        <section class="mb-10">

            <div class="flex items-center justify-between gap-4 flex-wrap">

                <div>

                    <h1 class="text-3xl font-black tracking-tight text-slate-800 mb-2">
                        Enviar comprovação
                    </h1>

                    <p class="text-sm text-slate-500">
                        Explique o ocorrido e envie evidências para análise da administração.
                    </p>

                </div>

                <a href="${pageContext.request.contextPath}/autenticado/meeting"
                   class="
                        inline-flex items-center gap-2
                        px-4 py-2.5
                        rounded-2xl
                        bg-white
                        border border-slate-200
                        text-sm font-semibold text-slate-700
                        hover:bg-slate-100
                        transition
                   ">

                    ← Voltar

                </a>

            </div>

        </section>

        <!-- CONTENT -->
        <div class="max-w-4xl">

            <div class="
                    bg-white
                    border border-slate-200
                    rounded-[30px]
                    shadow-sm
                    overflow-hidden
                 ">

                <!-- TOP -->
                <div class="
                        px-8 py-7
                        border-b border-slate-100
                        bg-gradient-to-r
                        from-indigo-600
                        to-violet-600
                     ">

                    <div class="flex items-center gap-4">

                        <div class="
                                w-14 h-14
                                rounded-2xl
                                bg-white/20
                                flex items-center justify-center
                                text-white text-2xl
                                backdrop-blur-sm
                             ">

                            📄

                        </div>

                        <div>

                            <h2 class="text-2xl font-bold text-white">
                                Solicitação de comprovação
                            </h2>

                            <p class="text-indigo-100 text-sm mt-1">
                                Sua resposta será analisada pela equipe administrativa.
                            </p>

                        </div>

                    </div>

                </div>

                <!-- FORM -->
                <form
                        action="${pageContext.request.contextPath}/autenticado/meeting/comprovation"
                        method="post"
                        enctype="multipart/form-data"
                        class="p-8 space-y-8"
                >

                    <input type="hidden"
                           name="reportId"
                           value="${report.id}">

                    <!-- INFO CARDS -->
                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-5">

                        <!-- REUNIÃO -->
                        <div class="
                                rounded-2xl
                                border border-slate-200
                                bg-slate-50
                                p-5
                             ">

                            <p class="
                                    text-xs
                                    font-semibold
                                    uppercase
                                    tracking-wide
                                    text-slate-400
                                    mb-2
                               ">

                                Reunião

                            </p>

                            <p class="text-sm font-bold text-slate-800 break-words">
                                ${report.getMeetingReport().getDescription()}
                            </p>

                        </div>

                        <!-- DATA -->
                        <div class="
                                rounded-2xl
                                border border-slate-200
                                bg-slate-50
                                p-5
                             ">

                            <p class="
                                    text-xs
                                    font-semibold
                                    uppercase
                                    tracking-wide
                                    text-slate-400
                                    mb-2
                               ">

                                Data

                            </p>

                            <p class="text-sm font-bold text-slate-800">
                                ${report.getMeetingReport().getDayTime()}
                            </p>

                        </div>

                        <!-- CATEGORIA -->
                        <div class="
                                rounded-2xl
                                border border-slate-200
                                bg-slate-50
                                p-5
                             ">

                            <p class="
                                    text-xs
                                    font-semibold
                                    uppercase
                                    tracking-wide
                                    text-slate-400
                                    mb-2
                               ">

                                Categoria

                            </p>

                            <span class="
                                    inline-flex items-center
                                    px-3 py-1
                                    rounded-full
                                    bg-amber-100
                                    text-amber-700
                                    text-xs
                                    font-bold
                                 ">

                                ${report.category}

                            </span>

                        </div>

                    </div>

                    <!-- DESCRIÇÃO -->
                    <div>

                        <label class="
                                block
                                text-sm
                                font-bold
                                text-slate-700
                                mb-3
                           ">

                            Justificativa

                        </label>

                        <textarea
                                name="evidenceDescription"
                                rows="7"
                                placeholder="Explique detalhadamente o motivo do não comparecimento..."
                                class="
                                    w-full
                                    rounded-2xl
                                    border border-slate-300
                                    bg-white
                                    px-5 py-4
                                    text-sm
                                    text-slate-700
                                    resize-none
                                    focus:outline-none
                                    focus:ring-4
                                    focus:ring-indigo-100
                                    focus:border-indigo-500
                                    transition
                                "
                        ></textarea>

                    </div>

                    <!-- UPLOAD -->
                    <div>

                        <label class="
                                block
                                text-sm
                                font-bold
                                text-slate-700
                                mb-3
                           ">

                            Evidência / Imagem

                        </label>

                        <div class="
                                rounded-2xl
                                border-2 border-dashed border-slate-300
                                bg-slate-50
                                p-6
                                hover:border-indigo-400
                                transition
                             ">

                            <input
                                    type="file"
                                    name="evidenceImage"
                                    class="
                                        w-full
                                        text-sm text-slate-500

                                        file:mr-4
                                        file:px-5
                                        file:py-2.5
                                        file:rounded-xl
                                        file:border-0
                                        file:text-sm
                                        file:font-semibold
                                        file:bg-indigo-600
                                        file:text-white
                                        hover:file:bg-indigo-700
                                        file:transition
                                    "
                            >

                            <p class="text-xs text-slate-400 mt-3">
                                Envie prints, documentos ou imagens que comprovem a situação.
                            </p>

                        </div>

                    </div>

                    <!-- ACTIONS -->
                    <div class="
                            flex flex-col sm:flex-row
                            gap-4
                            pt-2
                         ">

                        <a href="${pageContext.request.contextPath}/autenticado/meeting"
                           class="
                                flex-1
                                inline-flex items-center justify-center
                                px-6 py-3.5
                                rounded-2xl
                                border border-slate-300
                                bg-white
                                text-sm font-semibold text-slate-700
                                hover:bg-slate-100
                                transition
                           ">

                            Cancelar

                        </a>

                        <button
                                type="submit"
                                class="
                                    flex-1
                                    inline-flex items-center justify-center
                                    px-6 py-3.5
                                    rounded-2xl
                                    bg-indigo-600
                                    hover:bg-indigo-700
                                    text-white
                                    text-sm
                                    font-bold
                                    shadow-lg shadow-indigo-200
                                    transition
                                "
                        >

                            Enviar comprovação

                        </button>

                    </div>

                </form>

            </div>

        </div>

    </main>

</div>

</body>

</html>