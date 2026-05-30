<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%@ page import="com.aura.user.models.CommercialUser" %>
<%@ page import="com.aura.interest.model.Interest" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%

    List<CommercialUser> localUsers =
            (List<CommercialUser>) request.getAttribute("localUsers");

    List<CommercialUser> mentors =
            (List<CommercialUser>) request.getAttribute("mentors");

    Meeting upCommingMetting =
            (Meeting) request.getAttribute("upCommingMetting");

    DateTimeFormatter meetingFormatter =
            DateTimeFormatter.ofPattern("dd/MM/yyyy 'às' HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <title>Home</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>

<body class="bg-slate-50 min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="financial" />

<div class="flex flex-1">

    <t:menu paginaAtiva="dashboard" />

    <main class="flex-1 p-10 min-w-0">

        <c:if test="${showReportAlert}">
            <div class="fixed top-6 right-6 bg-yellow-100 border border-yellow-400
                text-yellow-800 px-6 py-4 rounded-xl shadow-lg max-w-md z-50">

                <h2 class="text-lg font-bold mb-2">
                    Comprovação solicitada
                </h2>

                <p class="text-sm mb-4">
                    Você recebeu uma denúncia de não comparecimento.
                    Envie uma comprovação para análise da administração.
                </p>

                <a href="${pageContext.request.contextPath}/autenticado/meeting?tab=comprovaçõesPendentes"
                   class="inline-block bg-yellow-500 hover:bg-yellow-600 text-white font-medium px-4 py-2 rounded-lg transition">
                    Enviar comprovação
                </a>

            </div>

        </c:if>
        <!-- HEADER -->
        <section class="mb-10">

            <h1 class="text-3xl font-black tracking-tight text-slate-800 mb-2">
                Bem-vindo, ${user.name}
            </h1>

            <p class="text-sm text-slate-500">
                Descubra mentores compatíveis com suas habilidades e interesses.
            </p>

        </section>

        <!-- TOP CARDS -->
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-6 mb-10">

            <!-- BALANCE -->
            <div class="relative overflow-hidden rounded-3xl p-7"
                 style="background: #7F77DD;">

                <p class="text-xs font-semibold tracking-widest uppercase mb-2.5"
                   style="color: #CECBF6;">

                    Saldo disponível

                </p>

                <p class="text-5xl font-bold text-white leading-none">

                    ${creditsBalance}

                    <span class="text-lg font-normal align-middle ml-1"
                          style="color: #CECBF6;">

                        Credits

                    </span>

                </p>

                <p class="text-sm mt-3 mb-6 leading-relaxed text-gray-200">

                    Você tem créditos suficientes para aproximadamente
                    ${creditsBalance / 60.0} horas de sessões de aprendizado.

                </p>

                <div class="flex gap-3">

                    <a href="${pageContext.request.contextPath}/autenticado/financial"
                       class="
                            flex-1
                            flex items-center justify-center
                            py-2.5
                            rounded-xl
                            bg-white
                            text-sm
                            font-semibold
                            transition
                            hover:opacity-90
                       "
                       style="color: #534AB7;">

                        + Add Credits

                    </a>

                    <a href="${pageContext.request.contextPath}/autenticado/financial/withdraw"
                       class="
                            flex-1
                            flex items-center justify-center
                            py-2.5
                            rounded-xl
                            text-sm
                            font-semibold
                            text-white
                            transition
                            hover:opacity-90
                       "
                       style="
                            background: rgba(255,255,255,0.15);
                            border: 1px solid rgba(255,255,255,0.3);
                       ">

                        Withdraw

                    </a>

                </div>

            </div>

            <!-- NEXT SESSION -->
            <div class="
                    rounded-3xl
                    border border-slate-200
                    bg-white
                    p-6
                    flex flex-col gap-5
                 ">

                <div class="flex items-center justify-between">

                    <h2 class="text-base font-bold text-slate-800">
                        Próxima Sessão
                    </h2>

                </div>

                <% if (upCommingMetting != null) { %>

                <!-- MENTOR -->
                <div class="flex items-center gap-4">

                    <div class="
                            w-12 h-12
                            rounded-2xl
                            flex items-center justify-center
                            text-white
                            text-base
                            font-bold
                            flex-shrink-0
                         "
                         style="background: linear-gradient(135deg, #7F77DD, #534AB7);">

                        <%= upCommingMetting
                                .getTeacher()
                                .getName()
                                .substring(0,1)
                                .toUpperCase() %>

                    </div>

                    <div class="min-w-0">

                        <p class="text-sm font-bold text-slate-800 truncate">

                            <%= upCommingMetting.getDescription() %>

                        </p>

                        <p class="text-xs text-slate-400">

                            with
                            <%= upCommingMetting.getTeacher()
                                    .getName() %>

                        </p>

                    </div>

                </div>

                <div class="border-t border-slate-100"></div>

                <!-- DETAILS -->
                <div class="flex flex-col gap-3">

                    <div class="flex items-center gap-2.5 text-sm text-slate-500">

                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="w-4 h-4 text-slate-400 flex-shrink-0"
                             fill="none"
                             viewBox="0 0 24 24"
                             stroke="currentColor"
                             stroke-width="1.8">

                            <path stroke-linecap="round"
                                  stroke-linejoin="round"
                                  d="M12 6v6l4 2m6-2a10 10 0 11-20 0 10 10 0 0120 0z"/>

                        </svg>

                        <span>

                            <%= upCommingMetting
                                    .getDayTime()
                                    .format(meetingFormatter) %>

                            •

                            <%= upCommingMetting
                                    .getDurationMinutes() %> min

                        </span>

                    </div>

                    <div class="flex items-center gap-2.5 text-sm text-slate-500">

                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="w-4 h-4 text-slate-400 flex-shrink-0"
                             fill="none"
                             viewBox="0 0 24 24"
                             stroke="currentColor"
                             stroke-width="1.8">

                            <path stroke-linecap="round"
                                  stroke-linejoin="round"
                                  d="M15 10l4.553-2.07A1 1 0 0121 8.82v6.36a1 1 0 01-1.447.894L15 14M3 8a2 2 0 012-2h8a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V8z"/>

                        </svg>

                        <span>Teams</span>

                    </div>

                </div>

                <% } else { %>

                <div class="
                        flex-1
                        flex items-center justify-center
                        rounded-2xl
                        bg-slate-50
                        border border-dashed border-slate-200
                        p-8
                     ">

                    <p class="text-sm text-slate-400">

                        Nenhuma sessão agendada.

                    </p>

                </div>

                <% } %>

                <a href="${pageContext.request.contextPath}/autenticado/meeting"
                   class="
                        flex items-center gap-1.5
                        text-sm font-semibold
                        mt-auto
                   "
                   style="color: #7F77DD;">

                    Manage all sessions

                    <svg xmlns="http://www.w3.org/2000/svg"
                         class="w-4 h-4"
                         fill="none"
                         viewBox="0 0 24 24"
                         stroke="currentColor"
                         stroke-width="2">

                        <path stroke-linecap="round"
                              stroke-linejoin="round"
                              d="M17 8l4 4m0 0l-4 4m4-4H3"/>

                    </svg>

                </a>

            </div>

        </div>

        <!-- MENTORS -->
        <section class="space-y-6">

            <div class="flex items-center justify-between">

                <div>

                    <h2 class="text-2xl font-bold text-slate-800">
                        Mentores recomendados
                    </h2>

                    <p class="text-sm text-slate-500 mt-1">
                        Usuários com habilidades parecidas com seus interesses.
                    </p>

                </div>

                <div class="flex items-center gap-3">

                    <button id="prevBtn"
                            class="
                                w-11 h-11
                                rounded-2xl
                                bg-white
                                border border-slate-200
                                shadow-sm
                                hover:bg-slate-100
                                transition
                                flex items-center justify-center
                            ">

                        ←

                    </button>

                    <span id="pageIndicator"
                          class="
                                text-sm
                                text-slate-400
                                font-medium
                                w-16
                                text-center
                          ">

                    </span>

                    <button id="nextBtn"
                            class="
                                w-11 h-11
                                rounded-2xl
                                bg-white
                                border border-slate-200
                                shadow-sm
                                hover:bg-slate-100
                                transition
                                flex items-center justify-center
                            ">

                        →

                    </button>

                </div>

            </div>

            <% if (mentors != null && !mentors.isEmpty()) { %>

            <div id="mentor-carousel"
                 class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

                <% for (CommercialUser cmmu : mentors) { %>

                <div class="
                        mentor-card
                        rounded-[28px]
                        border border-slate-200
                        bg-white
                        p-5
                        shadow-sm
                        hover:shadow-xl
                        hover:-translate-y-1
                        transition-all duration-300
                        flex flex-col
                     ">

                    <!-- HEADER -->
                    <div class="flex items-start justify-between mb-5">

                        <div class="flex items-center gap-3">

                            <div class="
                                    w-12 h-12
                                    rounded-2xl
                                    bg-gradient-to-br
                                    from-indigo-500
                                    to-violet-500
                                    text-white
                                    text-base
                                    font-bold
                                    flex items-center justify-center
                                    shadow-md
                                    flex-shrink-0
                                 ">

                                <%= cmmu.getName()
                                        .substring(0,1)
                                        .toUpperCase() %>

                            </div>

                            <div class="min-w-0">

                                <h3 class="text-sm font-bold text-slate-800 truncate">

                                    <%= cmmu.getName() %>

                                </h3>

                                <p class="text-xs text-slate-400 truncate">

                                    <%= cmmu.getEmail() %>

                                </p>

                            </div>

                        </div>


                    </div>

                    <!-- BODY -->
                    <div class="space-y-3 mb-5 flex-1">

                        <p class="text-xs leading-relaxed text-slate-500">

                            Mentor disponível para compartilhar conhecimentos
                            e colaborar no desenvolvimento de novas habilidades.

                        </p>

                        <div class="space-y-1 text-xs text-slate-600">

                            <p class="truncate">
                                📍 <%= cmmu.getAddress() %>
                            </p>

                            <p>
                                📞 <%= cmmu.getPhone() %>
                            </p>

                        </div>

                    </div>

                    <!-- SKILLS -->
                    <div class="mb-5">

                        <p class="
                                text-xs
                                font-semibold
                                text-slate-400
                                uppercase
                                mb-2
                           ">

                            Skills

                        </p>

                        <div class="flex flex-wrap gap-1.5">

                            <%
                                if (cmmu.getInterests() != null
                                        && !cmmu.getInterests().isEmpty()) {

                                    for (Interest interest : cmmu.getInterests()) {
                            %>

                            <span class="
                                    px-2.5 py-0.5
                                    rounded-full
                                    bg-indigo-50
                                    text-indigo-600
                                    text-xs
                                    font-semibold
                                 ">

                                <%= interest.getName() %>

                            </span>

                            <%
                                }
                            } else {
                            %>

                            <span class="
                                    px-2.5 py-0.5
                                    rounded-full
                                    bg-slate-100
                                    text-slate-500
                                    text-xs
                                    font-semibold
                                 ">

                                Sem skills

                            </span>

                            <% } %>

                        </div>

                    </div>

                    <!-- FOOTER -->
                    <a href="${pageContext.request.contextPath}/autenticado/users/profile?id=<%= cmmu.getId() %>"
                       class="
                            inline-flex items-center justify-center
                            px-4 py-2
                            rounded-xl
                            bg-indigo-600
                            hover:bg-indigo-700
                            text-white
                            text-xs
                            font-semibold
                            transition
                       ">

                        Ver perfil

                    </a>

                </div>

                <% } %>

            </div>

            <% } else { %>

            <div class="
        rounded-3xl
        border border-dashed border-slate-300
        bg-white
        p-14
        text-center
     ">

                <p class="text-slate-500">
                    Nenhum mentor compatível encontrado.
                </p>

            </div>

            <% } %>

        </section>

        <!-- LOCAL USERS -->
        <section class="space-y-6 mt-14">

                <div>

                    <h2 class="text-2xl font-bold text-slate-800">
                        Pessoas da sua cidade
                    </h2>

                    <p class="text-sm text-slate-500 mt-1">
                        Conecte-se com usuários próximos de você.
                    </p>

                </div>

                <% if (localUsers != null && !localUsers.isEmpty()) { %>

                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

                    <% for (CommercialUser localUser : localUsers) { %>

                    <div class="
                rounded-[28px]
                border border-slate-200
                bg-white
                p-5
                shadow-sm
                hover:shadow-xl
                hover:-translate-y-1
                transition-all duration-300
                flex flex-col
             ">

                        <!-- HEADER -->
                        <div class="flex items-start justify-between mb-5">

                            <div class="flex items-center gap-3">

                                <div class="
                            w-12 h-12
                            rounded-2xl
                            bg-[#7900ac]
                            to-teal-500
                            text-white
                            text-base
                            font-bold
                            flex items-center justify-center
                            shadow-md
                            flex-shrink-0
                         ">

                                    <%= localUser.getName()
                                            .substring(0,1)
                                            .toUpperCase() %>

                                </div>

                                <div class="min-w-0">

                                    <h3 class="text-sm font-bold text-slate-800 truncate">

                                        <%= localUser.getName() %>

                                    </h3>

                                    <p class="text-xs text-slate-400 truncate">

                                        <%= localUser.getEmail() %>

                                    </p>

                                </div>

                            </div>

                        </div>

                        <!-- BODY -->
                        <div class="space-y-3 mb-5 flex-1">

                            <p class="text-xs leading-relaxed text-slate-500">

                                Usuário disponível para networking,
                                troca de experiências e aprendizado.

                            </p>

                            <div class="space-y-1 text-xs text-slate-600">

                                <p class="truncate">
                                    📍 <%= localUser.getAddress() %>
                                </p>

                                <p>
                                    📞 <%= localUser.getPhone() %>
                                </p>

                            </div>

                        </div>

                        <!-- INTERESTS -->
                        <div class="mb-5">

                            <p class="
                        text-xs
                        font-semibold
                        text-slate-400
                        uppercase
                        mb-2
                   ">

                                Interesses

                            </p>

                            <div class="flex flex-wrap gap-1.5">

                                <%
                                    if (localUser.getInterests() != null
                                            && !localUser.getInterests().isEmpty()) {

                                        for (Interest interest : localUser.getInterests()) {
                                %>

                                <span class="
                            px-2.5 py-0.5
                            rounded-full
                            bg-[#7900ac]
                            text-emerald-600
                            text-xs
                            font-semibold
                         ">

                        <%= interest.getName() %>

                    </span>

                                <%
                                    }
                                } else {
                                %>

                                <span class="
                            px-2.5 py-0.5
                            rounded-full
                            bg-slate-100
                            text-slate-500
                            text-xs
                            font-semibold
                         ">

                        Sem interesses cadastrados

                    </span>

                                <% } %>

                            </div>

                        </div>

                        <!-- FOOTER -->
                        <a href="${pageContext.request.contextPath}/autenticado/users/profile?id=<%= localUser.getId() %>"
                           class="
                    inline-flex items-center justify-center
                    px-4 py-2
                    rounded-xl
                    bg-[#7900ac]
                    hover:bg-[#7900ac]
                    text-white
                    text-xs
                    font-semibold
                    transition
               ">

                            Ver perfil

                        </a>

                    </div>

                    <% } %>

                </div>

                <% } else { %>

                <div class="
            rounded-3xl
            border border-dashed border-slate-300
            bg-white
            p-14
            text-center
         ">

                    <p class="text-slate-500">
                        Nenhum usuário da sua cidade encontrado.
                    </p>

                </div>

                <% } %>

            </section>


        </section>

    </main>

</div>

<script>

    const CARDS_PER_PAGE = 4;

    const cards =
        Array.from(document.querySelectorAll(".mentor-card"));

    const prevBtn =
        document.getElementById("prevBtn");

    const nextBtn =
        document.getElementById("nextBtn");

    const indicator =
        document.getElementById("pageIndicator");

    let currentPage = 0;

    const totalPages =
        Math.ceil(cards.length / CARDS_PER_PAGE);

    function showPage(page) {

        cards.forEach((card, i) => {

            const inPage =
                i >= page * CARDS_PER_PAGE
                &&
                i < (page + 1) * CARDS_PER_PAGE;

            card.style.display =
                inPage ? "flex" : "none";

        });

        if (indicator) {

            indicator.textContent =
                totalPages > 1
                    ? `${page + 1} / ${totalPages}`
                    : "";

        }

        prevBtn.disabled = page === 0;

        nextBtn.disabled =
            page >= totalPages - 1;

        prevBtn.classList.toggle(
            "opacity-40",
            page === 0
        );

        nextBtn.classList.toggle(
            "opacity-40",
            page >= totalPages - 1
        );

    }

    if (cards.length > 0) {

        showPage(0);

        nextBtn.addEventListener("click", () => {

            if (currentPage < totalPages - 1) {

                currentPage++;

                showPage(currentPage);

            }

        });

        prevBtn.addEventListener("click", () => {

            if (currentPage > 0) {

                currentPage--;

                showPage(currentPage);

            }

        });

    }

</script>

</body>

</html>