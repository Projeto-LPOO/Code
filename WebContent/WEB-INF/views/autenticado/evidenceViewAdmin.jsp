<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>

<html lang="pt-BR">

<head>

  <meta charset="UTF-8">

  <title>Evidências</title>

  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

</head>

<body class="bg-slate-50 min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="meetings"/>

<div class="flex flex-1">

  <t:menuAdmin paginaAtiva="evidences"/>

  <main class="flex-1 p-10 min-w-0">

    <section class="mb-10">

      <div class="flex items-center justify-between flex-wrap gap-4">

        <div>

          <h1 class="text-3xl font-black tracking-tight text-slate-800">
            Evidências
          </h1>

          <p class="text-sm text-slate-500 mt-2">
            Gerencie e analise as comprovações enviadas pelos usuários.
          </p>

        </div>

      </div>

    </section>

    <div class="mb-8 flex flex-wrap gap-3">

      <button onclick="changeTab('pending')" id="tab-pending" class="tab-button bg-indigo-600 text-white px-5 py-3 rounded-2xl text-sm font-semibold transition">
            Pendentes (${evidencesPendentes.size()})
      </button>

      <button onclick="changeTab('approved')" id="tab-approved"
              class="tab-button bg-white border border-slate-200 text-slate-600 px-5 py-3 rounded-2xl text-sm font-semibold transition">
            Aprovadas (${evidencesApproved.size()})
      </button>

      <button onclick="changeTab('rejected')" id="tab-rejected"
              class="tab-button bg-white border border-slate-200 text-slate-600 px-5 py-3 rounded-2xl text-sm font-semibold transition">
        Recusadas (${evidencesRecused.size()})
      </button>

    </div>

    <section id="content-pending" class="tab-content">

      <c:if test="${empty evidencesPendentes}">

        <div class="rounded-3xl border border-dashed border-slate-300 bg-white p-16 text-center">

          <div class="text-5xl mb-4">
            📂
          </div>

          <h2 class="text-xl font-bold text-slate-700 mb-2">
            Nenhuma evidência pendente
          </h2>

          <p class="text-sm text-slate-500">
            Não existem comprovações aguardando análise.
          </p>

        </div>

      </c:if>

      <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">

        <c:forEach var="e" items="${evidencesPendentes}">

          <div class="bg-white rounded-[32px] border border-slate-200 shadow-sm overflow-hiddenhover:shadow-xl transition-all duration-300">

            <div class="p-6 border-b border-slate-100">

              <div class="flex items-start justify-between gap-4">

                <div class="flex items-center gap-4 min-w-0">

                  <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center text-white font-bold text-lg flex-shrink-0">

                      ${e.user.name.substring(0,1)}

                  </div>

                  <div class="min-w-0">

                    <h2 class="text-base font-bold text-slate-800 truncate">
                        ${e.user.name}
                    </h2>

                    <p class="text-sm text-slate-400 truncate">
                        ${e.user.email}
                    </p>

                  </div>

                </div>

                <div class="bg-green-100 text-green-700 px-4 py-2 rounded-xl text-xs font-bold">
                  PENDENTE
                </div>

              </div>

              <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                      Meeting
                  </p>

                  <p class="text-sm font-semibold text-slate-700 break-words">
                      ${e.report.meetingReport.description}
                  </p>

                </div>

                <div class="
                                    rounded-2xl
                                    bg-slate-50
                                    border border-slate-200
                                    p-4
                                ">

                  <p class="
                                        text-[11px]
                                        uppercase
                                        tracking-wide
                                        text-slate-400
                                        font-semibold
                                        mb-1
                                    ">
                    Reportado por
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.fromUser.name}
                  </p>

                </div>

                <div class="rounded-2xl
                                    bg-slate-50
                                    border border-slate-200
                                    p-4">

                  <p class="text-[11px]
                                        uppercase
                                        tracking-wide
                                        text-slate-400
                                        font-semibold
                                        mb-1">
                    Data da Meeting
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.meetingReport.dayTime}
                  </p>

                </div>

                <div class="rounded-2xl
                                    bg-slate-50
                                    border border-slate-200
                                    p-4">

                  <p class="text-[11px]
                                        uppercase
                                        tracking-wide
                                        text-slate-400
                                        font-semibold
                                        mb-1">
                    Data da Evidência
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.createdAt}
                  </p>

                </div>

                <div class="rounded-2xl
                                    bg-slate-50
                                    border border-slate-200
                                    p-4">

                  <p class="text-[11px]
                                        uppercase
                                        tracking-wide
                                        text-slate-400
                                        font-semibold
                                        mb-1">
                    Categoria
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.category}
                  </p>

                </div>

                <div class="rounded-2xl
                                    bg-slate-50
                                    border border-slate-200
                                    p-4">

                  <p class=" text-[11px]
                                        uppercase
                                        tracking-wide
                                        text-slate-400
                                        font-semibold
                                        mb-2">
                    Participantes
                  </p>

                  <div class="space-y-1">

                    <p class="text-sm font-semibold text-slate-700">
                       ${e.report.meetingReport.learner.name}
                    </p>

                    <p class="text-sm text-slate-600">
                       ${e.report.meetingReport.teacher.name}
                    </p>

                  </div>

                </div>

              </div>

            </div>

            <div class="bg-slate-100 px-6 pt-6">

              <div class="
                                w-full
                                rounded-3xl
                                overflow-hidden
                                border border-slate-200
                                bg-white
                            ">

                <img
                        src="${pageContext.request.contextPath}/evidenceuploads?file=${e.imagePath}"
                        alt="Evidência"
                        class="
                                            w-full
                                            h-[420px]
                                            object-contain
                                            bg-slate-100
                                        "
                />

              </div>

            </div>

            <div class="p-6">

              <h3 class="
                                text-sm
                                font-bold
                                text-slate-700
                                mb-3
                            ">
                Descrição da Evidência
              </h3>

              <div class="
                                rounded-2xl
                                bg-slate-50
                                border border-slate-200
                                p-5
                            ">

                <p class="
                                    text-sm
                                    leading-relaxed
                                    text-slate-600
                                    whitespace-pre-line
                                    break-words
                                ">
                    ${e.description}
                </p>

              </div>

            </div>

            <div class="px-6 pb-6 flex flex-col sm:flex-row gap-3">

              <form
                      method="post"
                      action="${pageContext.request.contextPath}/autenticado/admin/approve"
                      class="flex-1"
              >

                <input
                        type="hidden"
                        name="evidenceId"
                        value="${e.id}"
                />

                <input
                        type="hidden"
                        name="meetingId"
                        value="${e.report.meetingReport.id}"
                />

                <button class="
                                    w-full
                                    bg-green-600
                                    hover:bg-green-700
                                    text-white
                                    text-sm
                                    font-semibold
                                    px-4 py-3
                                    rounded-2xl
                                    transition
                                ">
                  Aprovar
                </button>

              </form>

              <form
                      method="post"
                      action="${pageContext.request.contextPath}/autenticado/admin/reject"
                      class="flex-1"
              >

                <input
                        type="hidden"
                        name="evidenceId"
                        value="${e.id}"
                />

                <input
                        type="hidden"
                        name="meetingId"
                        value="${e.report.meetingReport.id}"
                />

                <button class="
                                    w-full
                                    bg-red-600
                                    hover:bg-red-700
                                    text-white
                                    text-sm
                                    font-semibold
                                    px-4 py-3
                                    rounded-2xl
                                    transition
                                ">
                  Rejeitar
                </button>

              </form>

            </div>

          </div>

        </c:forEach>

      </div>

    </section>

    <section id="content-approved" class="tab-content hidden">

      <c:if test="${empty evidencesApproved}">

        <div class="
            rounded-3xl
            border border-dashed border-slate-300
            bg-white
            p-16
            text-center
        ">

          <div class="text-5xl mb-4">
            ✅
          </div>

          <h2 class="text-xl font-bold text-slate-700 mb-2">
            Nenhuma evidência aprovada
          </h2>

        </div>

      </c:if>

      <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">

        <c:forEach var="e" items="${evidencesApproved}">

          <div class="
                bg-white
                rounded-[32px]
                border border-slate-200
                shadow-sm
                overflow-hidden
            ">

            <div class="p-6 border-b border-slate-100">

              <div class="flex items-start justify-between gap-4">

                <div class="flex items-center gap-4 min-w-0">

                  <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center text-white font-bold text-lg flex-shrink-0">

                      ${e.user.name.substring(0,1)}

                  </div>

                  <div class="min-w-0">

                    <h2 class="text-base font-bold text-slate-800 truncate">
                        ${e.user.name}
                    </h2>

                    <p class="text-sm text-slate-400 truncate">
                        ${e.user.email}
                    </p>

                  </div>

                </div>

                <div class="bg-green-100 text-green-700 px-4 py-2 rounded-xl text-xs font-bold">
                    APROVADA
                </div>

              </div>

              <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Meeting
                  </p>

                  <p class="text-sm font-semibold text-slate-700 break-words">
                      ${e.report.meetingReport.description}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Reportado por
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.fromUser.name}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Data da Meeting
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.meetingReport.dayTime}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Data da Evidência
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.createdAt}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Categoria
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.category}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-2">
                    Participantes
                  </p>

                  <div class="space-y-1">

                    <p class="text-sm font-semibold text-slate-700">
                       ${e.report.meetingReport.learner.name}
                    </p>

                    <p class="text-sm text-slate-600">
                       ${e.report.meetingReport.teacher.name}
                    </p>

                  </div>

                </div>

              </div>

            </div>

            <div class="bg-slate-100 px-6 pt-6">

              <div class="
                        w-full
                        rounded-3xl
                        overflow-hidden
                        border border-slate-200
                        bg-white
                    ">

                <img
                        src="${pageContext.request.contextPath}/evidenceuploads?file=${e.imagePath}"
                        alt="Evidência"
                        class="
                                w-full
                                h-[420px]
                                object-contain
                                bg-slate-100
                            "
                />

              </div>

            </div>

            <div class="p-6">

              <h3 class="text-sm font-bold text-slate-700 mb-3">
                Descrição da Evidência
              </h3>

              <div class="
                        rounded-2xl
                        bg-slate-50
                        border border-slate-200
                        p-5
                    ">

                <p class="
                            text-sm
                            leading-relaxed
                            text-slate-600
                            whitespace-pre-line
                            break-words
                        ">
                    ${e.description}
                </p>

              </div>

            </div>

          </div>

        </c:forEach>

      </div>

    </section>


    <section id="content-rejected" class="tab-content hidden">

      <c:if test="${empty evidencesRecused}">

        <div class="
            rounded-3xl
            border border-dashed border-slate-300
            bg-white
            p-16
            text-center
        ">

          <div class="text-5xl mb-4">
            ✅
          </div>

          <h2 class="text-xl font-bold text-slate-700 mb-2">
            Nenhuma evidência recusada
          </h2>

        </div>

      </c:if>

      <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">

        <c:forEach var="e" items="${evidencesRecused}">

          <div class="
                bg-white
                rounded-[32px]
                border border-slate-200
                shadow-sm
                overflow-hidden
            ">

            <div class="p-6 border-b border-slate-100">

              <div class="flex items-start justify-between gap-4">

                <div class="flex items-center gap-4 min-w-0">

                  <div class="
                                w-14 h-14
                                rounded-2xl
                                bg-gradient-to-br
                                from-indigo-500
                                to-violet-600
                                flex items-center justify-center
                                text-white
                                font-bold
                                text-lg
                                flex-shrink-0
                            ">
                      ${e.user.name.substring(0,1)}
                  </div>

                  <div class="min-w-0">

                    <h2 class="text-base font-bold text-slate-800 truncate">
                        ${e.user.name}
                    </h2>

                    <p class="text-sm text-slate-400 truncate">
                        ${e.user.email}
                    </p>

                  </div>

                </div>

                <div class="bg-green-100 text-green-700 px-4 py-2 rounded-xl text-xs font-bold">
                  APROVADA
                </div>

              </div>

              <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Meeting
                  </p>

                  <p class="text-sm font-semibold text-slate-700 break-words">
                      ${e.report.meetingReport.description}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Reportado por
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.fromUser.name}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Data da Meeting
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.meetingReport.dayTime}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Data da Evidência
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.createdAt}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-1">
                    Categoria
                  </p>

                  <p class="text-sm font-semibold text-slate-700">
                      ${e.report.category}
                  </p>

                </div>

                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4">

                  <p class="text-[11px] uppercase tracking-wide text-slate-400 font-semibold mb-2">
                    Participantes
                  </p>

                  <div class="space-y-1">

                    <p class="text-sm font-semibold text-slate-700">
                       ${e.report.meetingReport.learner.name}
                    </p>

                    <p class="text-sm text-slate-600">
                       ${e.report.meetingReport.teacher.name}
                    </p>

                  </div>

                </div>

              </div>

            </div>

            <div class="bg-slate-100 px-6 pt-6">

              <div class="
                        w-full
                        rounded-3xl
                        overflow-hidden
                        border border-slate-200
                        bg-white
                    ">

                <img
                        src="${pageContext.request.contextPath}/evidenceuploads?file=${e.imagePath}"
                        alt="Evidência"
                        class="
                                w-full
                                h-[420px]
                                object-contain
                                bg-slate-100
                            "
                />

              </div>

            </div>

            <div class="p-6">

              <h3 class="text-sm font-bold text-slate-700 mb-3">
                Descrição da Evidência
              </h3>

              <div class="
                        rounded-2xl
                        bg-slate-50
                        border border-slate-200
                        p-5
                    ">

                <p class="
                            text-sm
                            leading-relaxed
                            text-slate-600
                            whitespace-pre-line
                            break-words
                        ">
                    ${e.description}
                </p>

              </div>

            </div>

          </div>

        </c:forEach>

      </div>

    </section>

  </main>

</div>

<script>

  function changeTab(tab) {

    document.querySelectorAll('.tab-content')
            .forEach(el => el.classList.add('hidden'));

    document.querySelectorAll('.tab-button')
            .forEach(el => {

              el.classList.remove(
                      'bg-indigo-600',
                      'text-white'
              );

              el.classList.add(
                      'bg-white',
                      'text-slate-600',
                      'border',
                      'border-slate-200'
              );

            });

    document
            .getElementById('content-' + tab)
            .classList.remove('hidden');

    const activeButton =
            document.getElementById('tab-' + tab);

    activeButton.classList.remove(
            'bg-white',
            'text-slate-600',
            'border',
            'border-slate-200'
    );

    activeButton.classList.add(
            'bg-indigo-600',
            'text-white'
    );

  }

</script>

</body>

</html>