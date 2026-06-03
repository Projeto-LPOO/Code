<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty profile.name ? profile.name : 'Meu Perfil'} | Infinity Aura</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-[#f5f7fb] min-h-screen text-slate-800 flex flex-col">

<t:header paginaAtiva="profile"/>

<div id="toastNotification" class="fixed top-5 right-5 z-50 transform translate-y-[-20px] opacity-0 pointer-events-none transition-all duration-300 ease-out px-5 py-3.5 rounded-xl shadow-lg font-semibold text-sm flex items-center gap-2">
    <span id="toastIcon"></span>
    <span id="toastMessage"></span>
</div>

<div class="flex flex-1">

    <t:menu paginaAtiva="profile"/>

    <main class="flex-1 p-10">

        <div class="w-full  flex flex-col gap-6">

            <section class="bg-white rounded-3xl p-6 border border-slate-200 shadow-[0_4px_20px_rgba(0,0,0,0.03)]">
                <div class="flex flex-col sm:flex-row items-center justify-between gap-6">

                    <div class="flex flex-col sm:flex-row items-center gap-4 text-center sm:text-left">
                        <div class="w-20 h-20 rounded-2xl bg-[#6d28d9] flex items-center justify-center text-white text-3xl font-black shadow-md">
                            <c:out value="${not empty profile.name ? profile.name.substring(0,1).toUpperCase() : 'U'}" />
                        </div>
                        <div>
                            <div class="flex items-center justify-center sm:justify-start gap-2">
                                <h1 class="text-2xl font-bold text-slate-900">${not empty profile.name ? profile.name : 'Nome não informado'}</h1>
                            </div>
                            <p class="text-sm text-slate-400 mt-1">${not empty profile.email ? profile.email : 'Email não cadastrado'}</p>

                            <p class="text-sm text-violet-600 font-medium mt-0.5">
                                ⭐ ${not empty averageRating ? averageRating : '0.0'} (${not empty totalReviews ? totalReviews : '0'} avaliações)
                            </p>
                        </div>
                    </div>

                    <div class="flex items-center gap-3 w-full sm:w-auto justify-center">
                        </a>
                        <button form="profileForm" type="submit" class="bg-[#6d28d9] hover:bg-violet-800 text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition shadow-sm cursor-pointer">
                            Salvar alterações
                        </button>
                    </div>

                </div>
            </section>

            <div class="flex border-b border-slate-200 bg-white rounded-t-2xl">
                <button type="button" id="profileTab" class="flex-1 py-4 text-center text-sm font-semibold border-b-2 border-violet-700 text-violet-700 transition cursor-pointer">
                    Perfil & Informações
                </button>
                <button type="button" id="reviewTab" class="flex-1 py-4 text-center text-sm font-medium text-slate-400 hover:text-slate-600 bg-slate-50/50 transition cursor-pointer">
                    Avaliações
                </button>
            </div>

            <form id="profileForm" action="${pageContext.request.contextPath}/autenticado/profile" method="POST">
                <div id="profileSection" class="flex flex-col gap-6">
                    <div class="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm">
                        <h2 class="text-lg font-bold text-slate-900 mb-1">Sobre mim</h2>
                        <div class="flex flex-col gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Professional Bio</label>
                                <textarea name="bio" rows="4" class="w-full border border-slate-200 rounded-xl p-3 text-slate-700 focus:outline-none focus:border-violet-500 transition resize-none"><c:out value="${profile.bio}" /></textarea>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Telefone / Contato</label>
                                <input type="text" name="phone" value="<c:out value='${profile.phone}' />" class="w-full md:w-1/2 border border-slate-200 rounded-xl p-3 text-slate-700 focus:outline-none focus:border-violet-500 transition">
                            </div>
                        </div>
                    </div>
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
                </div>
            </form>


            <div id="reviewSection" class="flex flex-col gap-6 hidden">
                <div class="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm">
                    <h2 class="text-lg font-bold text-slate-900 mb-4">
                        Avaliações Recebidas
                    </h2>

                    <div class="flex flex-col gap-4">

                        <c:choose>

                            <c:when test="${not empty feedbacks}">
                                <c:forEach items="${feedbacks}" var="fb">

                                    <div class="bg-slate-50 border border-slate-200 rounded-2xl p-5 shadow-sm">

                                        <div class="flex items-start justify-between mb-3">

                                            <div class="flex flex-col gap-1">
                                    <span class="text-sm font-semibold text-slate-900">
                                        ${fb.fromUserName}
                                    </span>

                                                <span class="text-xs text-slate-500">
                                                        ${fb.date}
                                                </span>
                                            </div>

                                            <div class="flex items-center gap-1">
                                    <span class="text-amber-500 text-sm">
                                        <c:forEach begin="1" end="${fb.rating}">
                                            ⭐
                                        </c:forEach>
                                    </span>

                                                <span class="text-xs text-slate-500">
                                        (${fb.rating}/5)
                                    </span>
                                            </div>

                                        </div>

                                        <p class="text-sm text-slate-700 leading-relaxed">
                                            <c:out value="${fb.comment}" />
                                        </p>

                                    </div>

                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <div class="text-center py-10">
                                    <p class="text-slate-400 italic">
                                        Nenhuma avaliação recebida ainda.
                                    </p>
                                </div>
                            </c:otherwise>

                        </c:choose>

                    </div>
                </div>
            </div>

            </form>

        </div>

    </main>

</div>

<footer class="text-center py-6 text-xs text-slate-400 lg:ml-[240px] border-t border-slate-200/60 mt-auto bg-white">
    &copy; 2026 Aura. Conectando pessoas pelo conhecimento.
</footer>

<script>
    document.addEventListener("DOMContentLoaded", () => {

        // ===== Abas =====
        const profileTab = document.getElementById("profileTab");
        const reviewTab = document.getElementById("reviewTab");
        const profileSection = document.getElementById("profileSection");
        const reviewSection = document.getElementById("reviewSection");

        const activeTab =
            "flex-1 py-4 text-center text-sm font-semibold border-b-2 border-violet-700 text-violet-700 transition cursor-pointer";

        const inactiveTab =
            "flex-1 py-4 text-center text-sm font-medium text-slate-400 hover:text-slate-600 bg-slate-50/50 transition cursor-pointer";

        if (profileTab && reviewTab && profileSection && reviewSection) {

            // Estado inicial
            profileSection.classList.remove("hidden");
            reviewSection.classList.add("hidden");

            profileTab.addEventListener("click", () => {
                profileTab.className = activeTab;
                reviewTab.className = inactiveTab;

                profileSection.classList.remove("hidden");
                reviewSection.classList.add("hidden");
            });

            reviewTab.addEventListener("click", () => {
                reviewTab.className = activeTab;
                profileTab.className = inactiveTab;

                profileSection.classList.add("hidden");
                reviewSection.classList.remove("hidden");
            });
        }

        // ===== Formulário =====
        const profileForm = document.getElementById("profileForm");

        if (profileForm) {
            profileForm.addEventListener("submit", async (event) => {
                event.preventDefault();

                const formData = new FormData(profileForm);
                const searchParams = new URLSearchParams(formData);

                try {
                    const response = await fetch(profileForm.action, {
                        method: "POST",
                        body: searchParams,
                        headers: {
                            "Content-Type":
                                "application/x-www-form-urlencoded; charset=UTF-8"
                        }
                    });

                    const result = await response.json();

                    if (response.ok && result.success) {
                        showToast(
                            result.message || "Perfil atualizado com sucesso!",
                            "success"
                        );
                    } else {
                        showToast(
                            result.message || "Erro ao salvar alterações.",
                            "error"
                        );
                    }

                } catch (error) {
                    console.error(error);
                    showToast(
                        "Erro de comunicação com o servidor.",
                        "error"
                    );
                }
            });
        }

        // ===== Toast =====
        function showToast(message, type) {
            const toast = document.getElementById("toastNotification");
            const icon = document.getElementById("toastIcon");
            const msg = document.getElementById("toastMessage");

            if (!toast || !icon || !msg) return;

            msg.textContent = message;

            toast.classList.remove(
                "bg-emerald-50",
                "text-emerald-800",
                "border-emerald-200",
                "bg-rose-50",
                "text-rose-800",
                "border-rose-200"
            );

            if (type === "success") {
                toast.classList.add(
                    "bg-emerald-50",
                    "text-emerald-800",
                    "border",
                    "border-emerald-200"
                );
                icon.textContent = "✅";
            } else {
                toast.classList.add(
                    "bg-rose-50",
                    "text-rose-800",
                    "border",
                    "border-rose-200"
                );
                icon.textContent = "❌";
            }

            toast.classList.remove(
                "opacity-0",
                "translate-y-[-20px]",
                "pointer-events-none"
            );

            toast.classList.add(
                "opacity-100",
                "translate-y-0"
            );

            setTimeout(() => {
                toast.classList.remove(
                    "opacity-100",
                    "translate-y-0"
                );

                toast.classList.add(
                    "opacity-0",
                    "translate-y-[-20px]",
                    "pointer-events-none"
                );
            }, 4000);
        }
    });
</script>
</body>
</html>