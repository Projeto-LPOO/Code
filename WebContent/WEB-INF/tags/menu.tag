<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="paginaAtiva" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="w-64 min-h-screen bg-[#FBFAF9] p-6 flex flex-col">

    <nav class="flex flex-col gap-3 text-md">

        <a href="${pageContext.request.contextPath}/autenticado/home"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'dashboard' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="3" y="3" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
                <rect x="13" y="3" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
                <rect x="3" y="13" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
                <rect x="13" y="13" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
            </svg>
            Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/autenticado/users"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'explore' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="10.5" cy="10.5" r="6.5" stroke="currentColor" stroke-width="1.8"/>
                <line x1="15.5" y1="15.5" x2="21" y2="21" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            Explore
        </a>

        <a href="${pageContext.request.contextPath}/autenticado/availability"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'agenda' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="3" y="5" width="18" height="16" rx="3" stroke="currentColor" stroke-width="1.8"/>
                <line x1="3" y1="10" x2="21" y2="10" stroke="currentColor" stroke-width="1.5"/>
                <line x1="8" y1="3" x2="8" y2="7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                <line x1="16" y1="3" x2="16" y2="7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                <circle cx="8" cy="15" r="1" fill="currentColor"/>
                <circle cx="12" cy="15" r="1" fill="currentColor"/>
                <circle cx="16" cy="15" r="1" fill="currentColor"/>
            </svg>
            Agenda
        </a>

        <%-- link temporario para listar meetings, dps vai para perfil ou qlqr outro place (by daniel) --%>
        <a href="${pageContext.request.contextPath}/autenticado/meeting"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'meetings' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="3" y="5" width="18" height="15" rx="3" stroke="currentColor" stroke-width="1.8"/>
                <circle cx="9" cy="12" r="2" stroke="currentColor" stroke-width="1.6"/>
                <circle cx="15" cy="12" r="2" stroke="currentColor" stroke-width="1.6"/>
                <line x1="11" y1="12" x2="13" y2="12" stroke="currentColor" stroke-width="1.5"/>
                <line x1="12" y1="3" x2="12" y2="5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
            </svg>
            Meetings
        </a>

        <a href="${pageContext.request.contextPath}/autenticado/financial"
           class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'financial' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="2" y="6" width="20" height="14" rx="3" stroke="currentColor" stroke-width="1.8"/>
                <line x1="2" y1="11" x2="22" y2="11" stroke="currentColor" stroke-width="1.5"/>
                <rect x="14" y="13.5" width="7" height="5" rx="1.5" stroke="currentColor" stroke-width="1.5"/>
                <circle cx="17.5" cy="16" r="1.2" fill="currentColor"/>
            </svg>
            Financeiro
        </a>

        <a href="${pageContext.request.contextPath}/autenticado/profile"
            class="flex items-center gap-3 p-2 rounded hover:bg-gray-100 ${paginaAtiva == 'financial' ? 'bg-[#f2ecf5] font-medium text-[#7c3aed]' : 'text-gray-500'}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="2" y="6" width="20" height="14" rx="3" stroke="currentColor" stroke-width="1.8"/>
                <line x1="2" y1="11" x2="22" y2="11" stroke="currentColor" stroke-width="1.5"/>
                <rect x="14" y="13.5" width="7" height="5" rx="1.5" stroke="currentColor" stroke-width="1.5"/>
                <circle cx="17.5" cy="16" r="1.2" fill="currentColor"/>
            </svg>
            Perfil
        </a>

    </nav>

    <a href="${pageContext.request.contextPath}/logout"
       class="mt-auto text-sm text-red-500 hover:underline">
        Sair
    </a>

</aside>
