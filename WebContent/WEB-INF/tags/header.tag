<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="paginaAtiva" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="sticky top-0 w-full z-50" style="background: rgba(255,255,255,0.92); backdrop-filter: blur(12px); border-bottom: 1px solid #f0e6ff; box-shadow: 0 1px 20px rgba(124,58,237,0.07);">
    <div class="flex items-center justify-between px-6 h-14">

        <!-- Logo -->
        <div class="flex items-center">
            <img src="${pageContext.request.contextPath}/assets/img/logos/logo-horizontal.png"
                 alt="Aura"
                 class="h-7">
        </div>

        <c:if test="${isCommercial}">

            <div class="flex items-center gap-2">

                <a href="${pageContext.request.contextPath}/autenticado/financial/"
                   class="flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium transition-all"
                   style="background: #faf5ff; border: 1px solid #e9d5ff; color: #7c3aed;">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                        <path d="M12 6v12M9 9h4.5a1.5 1.5 0 0 1 0 3H9m0 0h4.5a1.5 1.5 0 0 1 0 3H9" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                    <span style="color: #9333ea; font-weight: 600;">${creditsBalance}</span>
                    <span style="color: #a855f7; font-size: 11px;">créditos</span>
                    <span style="color: #c084fc; font-weight: 400; font-size: 14px; line-height: 1;">+</span>
                </a>


                <a href="${pageContext.request.contextPath}/autenticado/profile?id=${user.id}"
                   class="flex items-center justify-center rounded-full transition-all"
                   style="width:34px; height:34px; background:#faf5ff; border:1.5px solid #e9d5ff; color:#7c3aed;"
                   onmouseover="this.style.background='#ede9fe'; this.style.borderColor='#c4b5fd';"
                   onmouseout="this.style.background='#faf5ff'; this.style.borderColor='#e9d5ff';">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="7" r="4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </a>

            </div>
        </c:if>

    </div>
</header>