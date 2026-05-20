<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Avaliar Meeting | Infinity Aura</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/feedback.css">
</head>
<body class="bg-gray-50 min-h-screen">

<t:header paginaAtiva="meetings" />

<div class="flex flex-1">
    <t:menu paginaAtiva="meetings" />

    <main class="flex-1 flex items-start justify-center p-10">
        <div class="w-full max-w-lg bg-white border border-gray-200 rounded-2xl p-8 shadow-sm">

            <h2 class="text-xl font-bold text-gray-900 mb-1">
                ${isTeacher ? 'Avaliar Aluno' : 'Avaliar Professor'}
            </h2>
            <p class="text-sm text-gray-500 mb-6">
                Meeting <strong>#${meeting.id}</strong> —
                avaliando <strong>${targetName}</strong>
            </p>

            <%-- Mensagem de erro do controller --%>
            <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm mb-5">
                        ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/autenticado/feedback" method="POST">
                <input type="hidden" name="meetingId" value="${meeting.id}">

                <%-- Estrelas --%>
                <div class="mb-6">
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Nota *</label>
                    <div class="star-rating flex flex-row-reverse justify-end gap-1">
                        <input type="radio" id="5-stars" name="rating" value="5" required />
                        <label for="5-stars" class="text-3xl cursor-pointer text-gray-300 hover:text-yellow-400 peer-checked:text-yellow-400">★</label>
                        <input type="radio" id="4-stars" name="rating" value="4" />
                        <label for="4-stars" class="text-3xl cursor-pointer text-gray-300 hover:text-yellow-400">★</label>
                        <input type="radio" id="3-stars" name="rating" value="3" />
                        <label for="3-stars" class="text-3xl cursor-pointer text-gray-300 hover:text-yellow-400">★</label>
                        <input type="radio" id="2-stars" name="rating" value="2" />
                        <label for="2-stars" class="text-3xl cursor-pointer text-gray-300 hover:text-yellow-400">★</label>
                        <input type="radio" id="1-star"  name="rating" value="1" />
                        <label for="1-star"  class="text-3xl cursor-pointer text-gray-300 hover:text-yellow-400">★</label>
                    </div>
                </div>

                <%-- Comentário --%>
                <div class="mb-6">
                    <label for="comment" class="block text-sm font-semibold text-gray-700 mb-2">
                        Comentário *
                    </label>
                    <textarea name="comment" id="comment" rows="4" required
                              placeholder="${isTeacher ? 'Como foi o engajamento do aluno?' : 'Como foi sua experiência com o professor?'}"
                              class="w-full border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-800 resize-none focus:outline-none focus:ring-2 focus:ring-violet-500"></textarea>
                </div>

                <div class="flex gap-3">
                    <button type="submit"
                            class="flex-1 bg-violet-600 hover:bg-violet-700 text-white font-semibold text-sm py-2.5 rounded-xl transition-colors">
                        Enviar Avaliação
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