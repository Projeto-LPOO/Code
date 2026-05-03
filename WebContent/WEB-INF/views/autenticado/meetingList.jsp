<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ page import="com.aura.meeting.model.FaceToFaceMeeting" %>
<%@ page import="com.aura.meeting.model.OnlineMeeting" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Meetings</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body data-context="${pageContext.request.contextPath}">

<aside>
  <nav>
    <ul>
      <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
      <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuários</a></li>
      <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
      <li><a href="${pageContext.request.contextPath}/autenticado/meeting">Meetings</a></li>
      <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
    </ul>
  </nav>
</aside>

<main>
  <h1>Meetings</h1>

  <c:if test="${not empty error}">
    <p id="server-error" style="color:red;">${error}</p>
  </c:if>

  <a href="${pageContext.request.contextPath}/autenticado/meeting/register">+ Novo Meeting</a>

  <hr>

  <!-- lista de meets -->
  <section>
    <h2>Lista de Meetings</h2>
    <c:choose>
      <c:when test="${empty meetings}">
        <p>Nenhum meeting cadastrado.</p>
      </c:when>
      <c:otherwise>
        <c:forEach var="m" items="${meetings}">
        <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">

          <p><strong>Descrição:</strong> ${m.description}</p>
          <p><strong>Data/Hora:</strong> ${m.dayTime}</p>
          <p><strong>Status:</strong> ${m.status}</p>
          <p><strong>Tipo:</strong> ${tipoMap[m.id]}</p>

          <button type="button"
                  onclick="toggleEdit(this, '${m.id}', '${m.status}', '${tipoMap[m.id]}')">
            Editar
          </button>

          <form action="${pageContext.request.contextPath}/autenticado/meeting/delete"
                method="post" style="display:inline;"
                onsubmit="return confirm('Confirma exclusão?')">
            <input type="hidden" name="id" value="${m.id}">
            <button type="submit">Deletar</button>
          </form>

          <div class="editPanel" style="display:none; margin-top:10px;">
            <form action="${pageContext.request.contextPath}/autenticado/meeting/update"
                  method="post"
                  onsubmit="return validarEdicao(this, event)">
              <input type="hidden" name="id" class="editId">

              <label>Descrição: <input type="text" name="descricao" class="edit-descricao" required></label>
              <span class="erro-campo edit-erro-descricao"></span><br>

              <label>Data/Hora (dd/MM/yyyy HH:mm):
                <input type="text" name="dataHora" class="edit-dataHora" placeholder="25/12/2025 14:00">
              </label>
              <span class="erro-campo edit-erro-dataHora"></span><br>

              <label>Status:
                <select name="status">
                  <option value="pending">Pending</option>
                  <option value="confirmed">Confirmed</option>
                  <option value="cancelled">Cancelled</option>
                  <option value="completed">Completed</option>
                </select>
              </label><br>

              <div class="camposLocalizacao" style="display:none;">
                <label>Cidade: <input type="text" name="cidade" class="edit-cidade"></label>
                <span class="erro-campo edit-erro-cidade"></span><br>
                <label>Bairro: <input type="text" name="bairro"></label><br>
                <label>Rua: <input type="text" name="rua" class="edit-rua"></label>
                <span class="erro-campo edit-erro-rua"></span><br>
                <label>Número: <input type="number" name="numero" class="edit-numero"></label>
                <span class="erro-campo edit-erro-numero"></span><br>
                <label>Referência: <input type="text" name="referencia"></label><br>
              </div>

              <button type="submit">Salvar</button>
              <button type="button"
                      onclick="this.closest('.editPanel').style.display='none'">Cancelar</button>
            </form>
          </div>
        </div>
      </c:forEach>
      </c:otherwise>
    </c:choose>
  </section>
</main>

<style>
  .erro-campo { color: red; font-size: 0.85em; }
</style>

<script src="${pageContext.request.contextPath}/assets/js/meeting.js"></script>

</body>
</html>