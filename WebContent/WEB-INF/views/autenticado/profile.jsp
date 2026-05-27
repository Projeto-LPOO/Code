<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil - Aura</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-slate-50 min-h-screen text-gray-800 flex flex-col">

<t:header paginaAtiva="profile" />

<div class="flex flex-1">

    <t:menu paginaAtiva="profile" />

    <main class="flex-1 p-10 min-w-0 flex flex-col items-center">
        <form id="profileForm" action="${pageContext.request.contextPath}/autenticado/profile" method="post" class="w-full max-w-4xl space-y-8">

            <div class="bg-white rounded-[28px] border border-slate-200 p-6 flex justify-between items-center shadow-sm">
                <div class="flex items-center gap-5">
                    <div class="w-20 h-20 rounded-2xl flex items-center justify-center text-white text-3xl font-bold shadow-md shadow-indigo-100 flex-shrink-0"
                         style="background: linear-gradient(135deg, #7F77DD, #534AB7);">
                        <%
                            String name = (String) session.getAttribute("userName");
                            if(name == null) { name = "U"; }
                        %>
                        <%= name.substring(0,1).toUpperCase() %>
                    </div>

                    <div class="min-w-0">
                        <div class="flex items-center gap-2 flex-wrap">
                            <h2 class="text-2xl font-black tracking-tight text-slate-800 truncate">${user.name}</h2>
                            <span class="bg-indigo-50 text-indigo-600 text-xs px-2.5 py-0.5 rounded-full font-semibold border border-indigo-100">
                                Mentor
                            </span>
                        </div>
                        <div class="mt-1 flex items-center gap-4 text-xs text-slate-400 font-medium">
                            <span class="flex items-center gap-1">
                                📍 ${not empty profile.city ? profile.city : (not empty user.address ? user.address : 'Sua cidade')}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="flex items-center gap-3 flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/autenticado/users/profile?id=${user.id}"
                       class="border border-slate-200 hover:bg-slate-50 text-slate-700 text-xs font-semibold px-4 py-2.5 rounded-xl transition flex items-center gap-1.5 shadow-sm">
                        Seu perfil atual
                    </a>
                    <button type="submit"
                            class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold px-5 py-2.5 rounded-xl shadow-md shadow-indigo-100 transition cursor-pointer">
                        Salvar alterações
                    </button>
                </div>
            </div>

            <div class="border-b border-slate-200 flex gap-8">
                <button type="button" id="profileTab" class="pb-3 text-sm font-semibold border-b-2 border-indigo-600 text-indigo-600 transition cursor-pointer">
                    Perfil & Skills
                </button>
                <button type="button" id="reviewTab" class="pb-3 text-sm font-medium text-slate-400 hover:text-slate-600 transition cursor-pointer">
                    Avaliações
                </button>
            </div>

            <div id="profileSection" class="block space-y-6">
                <div class="bg-white rounded-[28px] border border-slate-200 p-6 space-y-5 shadow-sm">
                    <div>
                        <h3 class="text-base font-bold text-slate-800">Sobre mim</h3>
                        <p class="text-xs text-slate-400 mt-0.5">Conte à comunidade a sua história e explique por que você gosta de compartilhar conhecimento.</p>
                    </div>

                    <div class="space-y-2">
                        <label class="block text-xs font-semibold text-slate-400 uppercase tracking-wider">Professional Bio</label>
                        <textarea name="bio" rows="4" class="w-full border border-slate-200 rounded-xl p-3 text-sm focus:outline-none focus:border-indigo-400 resize-none transition bg-slate-50/50" placeholder="Fale sobre você...">${profile.bio}</textarea>
                    </div>

                    <div class="space-y-2">
                        <label class="block text-xs font-semibold text-slate-400 uppercase tracking-wider">Região / Cidade</label>
                        <input type="text" name="city" value="${not empty profile.city ? profile.city : user.address}" class="w-full max-w-md border border-slate-200 rounded-xl p-2.5 text-sm focus:outline-none focus:border-indigo-400 transition bg-slate-50/50" placeholder="Ex: Guanambi, BA" />
                    </div>
                </div>

                <div class="bg-white rounded-[28px] border border-slate-200 p-6 flex justify-between items-start shadow-sm">
                    <div class="space-y-1">
                        <h3 class="text-base font-bold text-slate-800">Habilidades de ensino</h3>
                        <p class="text-xs text-slate-400">Selecione habilidades que você possa compartilhar com outras pessoas.</p>
                    </div>
                    <button type="button" class="border border-slate-200 hover:bg-slate-50 text-slate-700 text-xs font-semibold px-3 py-1.5 rounded-lg transition flex items-center gap-1 cursor-pointer">
                        ➕ Add Skill
                    </button>
                </div>
            </div>

            <div id="reviewSection" class="hidden space-y-4">
                <c:choose>
                    <c:when test="${not empty feedbacks}">
                        <div class="grid grid-cols-1 gap-4">
                            <c:forEach var="review" items="${feedbacks}">
                                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm flex flex-col gap-2">
                                    <div class="flex justify-between items-center">
                                        <span class="font-bold text-slate-800 text-sm">Aluno (ID: ${review.fromUserId})</span>
                                        <span class="text-amber-500 font-semibold text-xs">
                                            <c:forEach begin="1" end="${review.rating}">⭐</c:forEach> (${review.rating}/5)
                                        </span>
                                    </div>
                                    <p class="text-slate-600 text-xs leading-relaxed">${review.comment}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-white rounded-[28px] border border-slate-200 p-12 text-center shadow-sm">
                            <p class="text-slate-400 text-sm">Nenhuma avaliação recebida ainda.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </form>
    </main>
</div>

<footer class="bg-white border-t border-slate-100 py-4 text-center text-xs text-slate-400">
    © 2026 Aura. Conectando pessoas pelo conhecimento.
</footer>

<script src="${pageContext.request.contextPath}/js/profile.js"></script>
</body>
</html>