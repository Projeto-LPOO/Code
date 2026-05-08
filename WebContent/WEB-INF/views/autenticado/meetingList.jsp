<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
  <meta charset="UTF-8">
  <title>Meetings</title>

  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-[#f6f5fb] min-h-screen text-gray-800"
      data-context="${pageContext.request.contextPath}">

<t:header paginaAtiva="meeting"/>

<div class="flex">

  <t:menu paginaAtiva="meeting"/>

  <main class="flex-1 p-10">

    <!-- HEADER -->
    <div class="flex items-center justify-between mb-10">

      <div>
        <h1 class="text-4xl font-bold text-gray-800 mb-2">
          My Meetings
        </h1>

        <p class="text-gray-500 text-sm">
          Gerencie seus meetings, confirme sessões e acompanhe status.
        </p>
      </div>

      <a href="${pageContext.request.contextPath}/autenticado/users"
         class="bg-violet-600 hover:bg-violet-700 transition text-white px-6 py-3 rounded-2xl font-semibold shadow-sm">

        + Novo Meeting

      </a>

    </div>

    <!-- TABS -->
    <div class="flex gap-8 border-b border-gray-200 mb-8 text-sm font-semibold">

      <div class="pb-4 border-b-2 border-violet-600 text-violet-700">
        Pending
      </div>

      <div class="pb-4 text-gray-400">
        Confirmed
      </div>

      <div class="pb-4 text-gray-400">
        Done
      </div>

      <div class="pb-4 text-gray-400">
        Cancelled
      </div>

    </div>

    <!-- LISTA -->
    <div class="space-y-5">

      <c:forEach var="m" items="${meetings}">

        <!-- CARD -->
        <div class="meeting-card bg-white rounded-3xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition">

          <div class="flex items-center justify-between">

            <!-- ESQUERDA -->
            <div class="flex gap-5">

              <!-- AVATAR -->
              <div class="w-14 h-14 rounded-full bg-gradient-to-br from-violet-500 to-fuchsia-500 flex items-center justify-center text-white font-bold text-lg shadow">

                  ${m.description.charAt(0)}

              </div>

              <!-- INFOS -->
              <div>

                <div class="flex items-center gap-3 mb-2">

                  <h2 class="text-xl font-bold text-gray-800">
                      ${m.description}
                  </h2>

                  <!-- STATUS -->
                  <c:choose>

                    <c:when test="${m.status == 'pending'}">
                                            <span class="bg-yellow-100 text-yellow-700 text-xs font-bold px-3 py-1 rounded-full">
                                                Pending
                                            </span>
                    </c:when>

                    <c:when test="${m.status == 'confirmed'}">
                                            <span class="bg-violet-100 text-violet-700 text-xs font-bold px-3 py-1 rounded-full">
                                                Confirmed
                                            </span>
                    </c:when>

                    <c:when test="${m.status == 'done'}">
                                            <span class="bg-green-100 text-green-700 text-xs font-bold px-3 py-1 rounded-full">
                                                Done
                                            </span>
                    </c:when>

                    <c:when test="${m.status == 'cancelled'}">
                                            <span class="bg-red-100 text-red-700 text-xs font-bold px-3 py-1 rounded-full">
                                                Cancelled
                                            </span>
                    </c:when>

                  </c:choose>

                </div>

                <div class="space-y-1 text-sm text-gray-500">

                  <p>
                    📅 ${m.dayTime}
                  </p>

                  <p>
                    💻 ${tipoMap[m.id]}
                  </p>

                  <c:if test="${not empty m.category}">
                    <p>
                      📚 ${m.category.name}
                    </p>
                  </c:if>

                </div>

              </div>

            </div>

            <!-- BOTÕES -->
            <div class="flex gap-3">

              <!-- EDITAR -->
              <button type="button"
                      class="bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold px-5 py-3 rounded-xl transition"
                      onclick="toggleEdit(this, '${m.id}', '${m.status}', '${m.description}', '${m.dayTime}')">

                Editar

              </button>

              <!-- DELETE -->
              <form action="${pageContext.request.contextPath}/autenticado/meeting/delete"
                    method="post"
                    onsubmit="return confirm('Confirma exclusão?')">

                <input type="hidden" name="id" value="${m.id}">

                <button type="submit"
                        class="bg-red-500 hover:bg-red-600 text-white font-semibold px-5 py-3 rounded-xl transition">

                  Deletar

                </button>

              </form>

            </div>

          </div>

          <!-- PAINEL -->
          <div class="editPanel hidden mt-6 border-t border-gray-100 pt-6">

            <form action="${pageContext.request.contextPath}/autenticado/meeting/update"
                  method="post"
                  class="space-y-5"
                  onsubmit="return validateEditForm(this, event)">

              <input type="hidden" name="id" class="editId">

              <!-- DESCRIÇÃO -->
              <div>

                <label class="block text-sm font-semibold mb-2 text-gray-700">
                  Descrição
                </label>

                <input type="text"
                       name="descricao"
                       class="edit-descricao w-full border border-gray-200 rounded-2xl px-4 py-3 outline-none focus:ring-2 focus:ring-violet-500">

                <span class="erro-campo text-red-500 text-sm edit-erro-descricao"></span>

              </div>

              <!-- DATA -->
              <div>

                <label class="block text-sm font-semibold mb-2 text-gray-700">
                  Data/Hora
                </label>

                <input type="text"
                       name="dataHora"
                       class="edit-dataHora w-full border border-gray-200 rounded-2xl px-4 py-3 outline-none focus:ring-2 focus:ring-violet-500">

                <span class="erro-campo text-red-500 text-sm edit-erro-dataHora"></span>

              </div>

              <!-- STATUS -->
              <div>

                <label class="block text-sm font-semibold mb-2 text-gray-700">
                  Status
                </label>

                <select name="status"
                        class="w-full border border-gray-200 rounded-2xl px-4 py-3 outline-none focus:ring-2 focus:ring-violet-500">

                  <option value="pending">Pending</option>
                  <option value="confirmed">Confirmed</option>
                  <option value="done">Done</option>
                  <option value="cancelled">Cancelled</option>

                </select>

              </div>

              <!-- ACTIONS -->
              <div class="flex gap-3 pt-2">

                <button type="submit"
                        class="bg-violet-600 hover:bg-violet-700 text-white px-6 py-3 rounded-2xl font-semibold transition">

                  Salvar

                </button>

                <button type="button"
                        onclick="this.closest('.editPanel').classList.add('hidden')"
                        class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-2xl font-semibold transition">

                  Cancelar

                </button>

              </div>

            </form>

          </div>

        </div>

      </c:forEach>

    </div>

  </main>

</div>

<script src="${pageContext.request.contextPath}/assets/js/meetingList.js"></script>

</body>

</html>