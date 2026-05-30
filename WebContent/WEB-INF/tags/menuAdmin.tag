<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="paginaAtiva" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="w-64 min-h-screen bg-[#FBFAF9] p-6 flex flex-col">

    <nav class="flex flex-col gap-3 text-md">

        <a href="${pageContext.request.contextPath}/autenticado/admin"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'dashboard' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="3" y="3" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
                <rect x="13" y="3" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
                <rect x="3" y="13" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
                <rect x="13" y="13" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
            </svg>
            Dashboard
        </a>



        </a>

        <a href="${pageContext.request.contextPath}/autenticado/admin/evidences"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'evidences' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="2" y="6" width="20" height="14" rx="3" stroke="currentColor" stroke-width="1.8"/>
                <line x1="2" y1="11" x2="22" y2="11" stroke="currentColor" stroke-width="1.5"/>
                <rect x="14" y="13.5" width="7" height="5" rx="1.5" stroke="currentColor" stroke-width="1.5"/>
                <circle cx="17.5" cy="16" r="1.2" fill="currentColor"/>
            </svg>
            Evidencias
        </a>

    </nav>

    <a href="${pageContext.request.contextPath}/logout"
       class="mt-auto text-sm text-red-500 hover:underline">
        Sair
    </a>

</aside>
