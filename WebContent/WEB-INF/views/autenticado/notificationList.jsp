<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Notificações | Infinity Aura</title>
  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-white min-h-screen">

<t:header paginaAtiva="notification" />

<div class="flex flex-1">

  <t:menu paginaAtiva="notification" />

  <main class="flex-1 p-10">

    <div class="flex items-center justify-between mb-7">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Notificações</h1>
        <p class="text-sm text-gray-500 mt-1">Acompanhe as atualizações dos seus meetings.</p>
      </div>
      <c:if test="${unreadCount > 0}">
        <button onclick="markAllRead()"
                class="text-sm text-violet-600 hover:underline font-medium cursor-pointer">
          Marcar todas como lidas
        </button>
      </c:if>
    </div>

    <c:choose>
      <c:when test="${empty notifications}">
        <div class="bg-white border border-gray-200 rounded-2xl p-16 text-center">
          <svg class="mx-auto mb-4 text-gray-300" width="48" height="48" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M13.73 21a2 2 0 0 1-3.46 0" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <p class="text-sm font-semibold text-gray-500">Nenhuma notificação ainda.</p>
        </div>
      </c:when>
      <c:otherwise>
        <section class="flex flex-col gap-3">
          <c:forEach var="n" items="${notifications}">
            <div class="bg-white border ${n.read ? 'border-gray-200' : 'border-violet-200'} ${n.read ? '' : 'bg-violet-50'} rounded-2xl p-5 flex items-start gap-4">

              <div class="shrink-0 mt-0.5">
                <c:choose>
                  <c:when test="${n.type == 'MEETING_CONFIRMED'}">
                    <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-green-100 text-green-600 text-base font-bold">✓</span>
                  </c:when>
                  <c:when test="${n.type == 'MEETING_CANCELLED' || n.type == 'MEETING_CANCELLED_BY_TEACHER'}">
                    <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-red-100 text-red-500 text-base font-bold">✕</span>
                  </c:when>
                  <c:when test="${n.type == 'MEETING_DONE'}">
                    <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-gray-100 text-gray-600 text-base">⭐</span>
                  </c:when>
                  <c:when test="${n.type == 'MEETING_REPORTED'}">
                    <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-orange-100 text-orange-600 text-base">⚑</span>
                  </c:when>
                  <c:otherwise>
                    <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-violet-100 text-violet-600 text-base">🔔</span>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2 mb-1">
                  <p class="text-sm font-semibold text-gray-900">${n.title}</p>
                  <c:if test="${!n.read}">
                    <span class="w-2 h-2 rounded-full bg-violet-500 shrink-0 inline-block"></span>
                  </c:if>
                </div>
                <p class="text-sm text-gray-600 leading-relaxed">${n.message}</p>
                <p class="text-xs text-gray-400 mt-2">${n.createdAt}</p>
              </div>

              <div class="shrink-0">
                <a href="${pageContext.request.contextPath}/autenticado/notification/go?id=${n.id}"
                   class="inline-block bg-violet-600 hover:bg-violet-700 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-colors">
                  Ir
                </a>
              </div>

            </div>
          </c:forEach>
        </section>
      </c:otherwise>
    </c:choose>

  </main>
</div>

<%-- popup exibido em todas as páginas exceto a própria aba de notificações --%>
<c:if test="${unreadCount > 0}">
  <div id="notif-popup"
       class="fixed bottom-6 right-6 z-50 bg-white border border-violet-200 shadow-xl rounded-2xl p-4 w-72">
    <div class="flex items-center justify-between mb-3">
      <p class="text-sm font-semibold text-gray-800">
        🔔 <c:out value="${unreadCount}"/> nova<c:if test="${unreadCount > 1}">s</c:if> notificaç<c:choose><c:when test="${unreadCount == 1}">ão</c:when><c:otherwise>ões</c:otherwise></c:choose>
      </p>
      <button onclick="document.getElementById('notif-popup').remove()"
              class="text-gray-400 hover:text-gray-600 text-xl leading-none cursor-pointer">&times;</button>
    </div>
    <a href="${pageContext.request.contextPath}/autenticado/notification"
       class="block text-center text-xs font-semibold bg-violet-600 hover:bg-violet-700 text-white py-2 rounded-xl transition-colors">
      Ver notificações
    </a>
  </div>
</c:if>

<script>
  function markAllRead() {
    fetch('${pageContext.request.contextPath}/autenticado/notification/read-all')
            .then(() => location.reload());
  }
</script>

</body>
</html>