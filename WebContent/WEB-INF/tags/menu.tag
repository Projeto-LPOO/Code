<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="paginaAtiva" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="w-64 min-h-screen bg-[#FBFAF9] p-6 flex flex-col">

    <nav class="flex flex-col gap-3 text-sm">
        <a href="${pageContext.request.contextPath}/autenticado/home"
           class="hover:bg-gray-100 p-2 rounded ${paginaAtiva == 'dashboard' ? 'bg-[#f2ecf5] font-medium' : ''}">
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/autenticado/users"
           class="hover:bg-gray-100 p-2 rounded ${paginaAtiva == 'explore' ? 'bg-[#f2ecf5] font-medium' : ''}">
            Explore
        </a>
        <a href="${pageContext.request.contextPath}/autenticado/availability"
           class="hover:bg-gray-100 p-2 rounded ${paginaAtiva == 'agenda' ? 'bg-[#f2ecf5] font-medium' : ''}">
            Agenda
        </a>
        <a href="${pageContext.request.contextPath}/autenticado/financial"
           class="hover:bg-gray-100 p-2 rounded ${paginaAtiva == 'financial' ? 'bg-[#f2ecf5] font-medium' : ''}">
            Financeiro
        </a>

    </nav>

    <a href="${pageContext.request.contextPath}/logout"
       class="mt-auto text-sm text-red-500 hover:underline">
        Sair
    </a>
</aside>