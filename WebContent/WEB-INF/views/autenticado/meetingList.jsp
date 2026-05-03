<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
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
<body>

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
    <p style="color:red;">${error}</p>
  </c:if>

  <!-- ===== CADASTRAR MEETING ===== -->
  <section>
    <h2>Cadastrar Meeting</h2>
    <form action="${pageContext.request.contextPath}/autenticado/meeting/save" method="post">

      <label>Tipo:
        <select name="tipo" id="tipoSelectCadastro" onchange="toggleCadastro()">
          <option value="online">Online</option>
          <option value="presencial">Presencial</option>
        </select>
      </label><br>

      <label>Descrição: <input type="text" name="descricao" required></label><br>
      <label>Data/Hora (dd/MM/yyyy HH:mm): <input type="text" name="dataHora" required placeholder="25/12/2025 14:00"></label><br>

      <div id="cadastroOnline">
        <label>Link/Plataforma: <input type="text" name="link"></label><br>
      </div>

      <div id="cadastroPresencial" style="display:none;">
        <label>Cidade: <input type="text" name="cidade"></label><br>
        <label>Bairro: <input type="text" name="bairro"></label><br>
        <label>Rua: <input type="text" name="rua"></label><br>
        <label>Número: <input type="number" name="numero"></label><br>
        <label>Ponto de referência: <input type="text" name="referencia"></label><br>
        <label>Instruções (opcional): <input type="text" name="instrucoes"></label><br>
      </div>

      <button type="submit">Cadastrar</button>
    </form>
  </section>

  <hr>

  <!-- ===== LISTA DE MEETINGS ===== -->
  <section>
    <h2>Lista de Meetings</h2>
    <c:choose>
      <c:when test="${empty meetings}">
        <p>Nenhum meeting cadastrado.</p>
      </c:when>
      <c:otherwise>
        <c:forEach var="m" items="${meetings}">
          <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
            <p>${m}</p>

            <!-- Buscar detalhes para editar/deletar exige o ID.
                 O DAO retorna strings no formato: MEETING[N] | id | status | tipo | category_id
                 Extraímos o id via JS ao expandir o painel de edição. -->

            <button onclick="toggleEdit(this, '${m}')">Editar</button>

            <form action="${pageContext.request.contextPath}/autenticado/meeting/delete"
                  method="post" style="display:inline;"
                  onsubmit="return confirm('Confirma exclusão?')">
              <input type="hidden" name="id" value="" class="deleteId">
              <button type="submit">Deletar</button>
            </form>

            <!-- Painel de edição (oculto por padrão) -->
            <div class="editPanel" style="display:none; margin-top:10px;">
              <form action="${pageContext.request.contextPath}/autenticado/meeting/update" method="post">
                <input type="hidden" name="id" class="editId">

                <label>Descrição: <input type="text" name="descricao" required></label><br>
                <label>Data/Hora (dd/MM/yyyy HH:mm): <input type="text" name="dataHora" required placeholder="25/12/2025 14:00"></label><br>
                <label>Status:
                  <select name="status">
                    <option value="pending">Pending</option>
                    <option value="confirmed">Confirmed</option>
                    <option value="cancelled">Cancelled</option>
                    <option value="completed">Completed</option>
                  </select>
                </label><br>

                <!-- Campos de localização aparecem só se for presencial -->
                <div class="camposLocalizacao" style="display:none;">
                  <label>Cidade: <input type="text" name="cidade"></label><br>
                  <label>Bairro: <input type="text" name="bairro"></label><br>
                  <label>Rua: <input type="text" name="rua"></label><br>
                  <label>Número: <input type="number" name="numero"></label><br>
                  <label>Referência: <input type="text" name="referencia"></label><br>
                </div>

                <button type="submit">Salvar alterações</button>
                <button type="button" onclick="this.closest('.editPanel').style.display='none'">Cancelar</button>
              </form>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </section>
</main>

<script>
  // Cadastro: alterna campos online/presencial
  function toggleCadastro() {
    const tipo = document.getElementById('tipoSelectCadastro').value;
    document.getElementById('cadastroOnline').style.display    = tipo === 'online'     ? 'block' : 'none';
    document.getElementById('cadastroPresencial').style.display = tipo === 'presencial' ? 'block' : 'none';
  }

  // Edição: extrai o ID da string do DAO e abre o painel
  // Formato esperado: "MEETING[N] | id | status | tipo | category_id"
  function toggleEdit(btn, meetingStr) {
    const card  = btn.closest('div');
    const panel = card.querySelector('.editPanel');

    if (panel.style.display === 'block') {
      panel.style.display = 'none';
      return;
    }

    // Extrai partes da string
    const parts  = meetingStr.split('|').map(s => s.trim());
    // parts[0] = "MEETING[N] ", parts[1] = id, parts[2] = status, parts[3] = tipo
    const id     = parts[1];
    const status = parts[2];
    const tipo   = parts[3]; // "PRESENCIAL" ou "ONLINE"

    // Preenche campos ocultos e selects
    panel.querySelector('.editId').value = id;
    card.querySelector('.deleteId').value = id;

    const statusSelect = panel.querySelector('select[name="status"]');
    for (let opt of statusSelect.options) {
      if (opt.value === status) opt.selected = true;
    }

    // Mostra campos de localização se presencial
    const locDiv = panel.querySelector('.camposLocalizacao');
    locDiv.style.display = tipo.toUpperCase() === 'PRESENCIAL' ? 'block' : 'none';

    panel.style.display = 'block';
  }
</script>

</body>
</html>