<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Reportar Meeting | Infinity Aura</title>
  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-gray-50 min-h-screen">

<t:header paginaAtiva="meetings" />

<div class="flex flex-1">
  <t:menu paginaAtiva="meetings" />

  <main class="flex-1 flex items-start justify-center p-10">
    <div class="w-full max-w-lg bg-white border border-gray-200 rounded-2xl p-8 shadow-sm">

      <h2 class="text-xl font-bold text-gray-900 mb-1">Reportar Meeting</h2>
      <p class="text-sm text-gray-500 mb-6">
        Meeting <strong>#${meeting.id}</strong> — descreva o motivo do report. Nossa equipe irá analisar.
      </p>

      <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm mb-5">
            ${error}
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/autenticado/meeting/report" method="POST">
        <input type="hidden" name="meetingId" value="${meeting.id}">

        <div class="mb-6">
          <label for="reason" class="block text-sm font-semibold text-gray-700 mb-2">
            Motivo *
          </label>
          <div class="flex flex-col gap-3">

            <label class="cursor-pointer">
              <input type="radio" name="category"
                     value="NAO_COMPARECEU"
                     class="peer hidden" required>

              <div class="border rounded-lg p-4 transition
                            peer-checked:bg-red-500
                            peer-checked:text-white
                            peer-checked:border-red-500
                            hover:border-red-300">
                NÃO COMPARECEU
              </div>
            </label>

            <label class="cursor-pointer">
              <input type="radio" name="category"
                     value="ASSEDIO"
                     class="peer hidden">

              <div class="border rounded-lg p-4 transition
                            peer-checked:bg-red-500
                            peer-checked:text-white
                            peer-checked:border-red-500
                            hover:border-red-300">
                ASSÉDIO
              </div>
            </label>

            <label class="cursor-pointer">
              <input type="radio" name="category"
                     value="VIOLENCIA"
                     class="peer hidden">

              <div class="border rounded-lg p-4 transition
                            peer-checked:bg-red-500
                            peer-checked:text-white
                            peer-checked:border-red-500
                            hover:border-red-300">
                VIOLÊNCIA
              </div>
            </label>
          </div>
          <textarea name="description" id="description" rows="5"
                    placeholder="Descreva o que aconteceu de errado neste meeting..."
                    class="w-full border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-800 resize-none focus:outline-none focus:ring-2 focus:ring-red-400"></textarea>
        </div>

        <div class="flex gap-3">
          <button type="submit"
                  class="flex-1 bg-red-600 hover:bg-red-700 text-white font-semibold text-sm py-2.5 rounded-xl transition-colors">
            Enviar Report
          </button>
          <a href="${pageContext.request.contextPath}/autenticado/meeting"
             class="flex-1 text-center bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold text-sm py-2.5 rounded-xl transition-colors">
            Voltar
          </a>
        </div>
      </form>

    </div>
  </main>
</div>

</body>
</html>