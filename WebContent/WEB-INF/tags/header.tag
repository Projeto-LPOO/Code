<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="paginaAtiva" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="sticky top-0  w-full bg-white shadow-sm px-6 py-3 flex items-center justify-between z-50">


    <div class="flex items-center gap-3">
        <img src="${pageContext.request.contextPath}/assets/img/logos/logo-horizontal.png"
             alt="Aura"
             class="h-8">
    </div>

    <div class="flex items-center">
        <a href="${pageContext.request.contextPath}/autenticado/financial/"
           class="flex items-center gap-2 bg-[#f3e8ff] text-[#6b21a8] px-3 py-2 rounded-full text-xs font-medium border border-[#e9d5ff]">

        <span class="uppercase text-xs tracking-wide text-gray-500">

            Créditos
        </span>

            <span class="font-semibold text-[#8324a8]">
                ${creditsBalance}
            </span>

            <span class="ml-1 text-lg leading-none">
            +
        </span>

        </a>
    </div>
</header>