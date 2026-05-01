<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aura.availability.models.Availability" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Aura - Disponibilidade</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/home.css">

    <script>
        function showNewForm() {
            document.getElementById('form-container').style.display = 'block';
            document.getElementById('form-title').innerText = 'Adicionar Disponibilidade';
            document.getElementById('input-id').value = '';
            document.getElementById('form-availability').action = '${pageContext.request.contextPath}/autenticado/availability/save';
        }

        function editar(id, dia, inicio, fim) {
            document.getElementById('form-container').style.display = 'block';
            document.getElementById('form-title').innerText = 'Editar Disponibilidade';
            document.getElementById('input-id').value = id;
            document.getElementById('select-dia').value = dia;
            document.getElementById('input-inicio').value = inicio;
            document.getElementById('input-fim').value = fim;
            document.getElementById('form-availability').action = '${pageContext.request.contextPath}/autenticado/availability/edit';
        }

        function fecharForm() {
            document.getElementById('form-container').style.display = 'none';
        }

        function toggleStatus(id) {
            document.getElementById('form-status-' + id).submit();
        }
    </script>
</head>
<body>
<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de Usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>
    <section>
        <h2>Meus Horários</h2>

        <%-- EXIBIÇÃO DE MENSAGENS DE ERRO --%>
        <% if(request.getAttribute("error") != null) { %>
            <div style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb; text-align: center;">
                <strong>Atenção:</strong> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <button onclick="showNewForm()" style="padding: 10px; margin-bottom: 20px; cursor:pointer;">
            + Adicionar Disponibilidade
        </button>

        <div id="form-container" style="display:none; border: 1px solid #ccc; padding: 20px; margin-bottom: 20px; background: #f9f9f9; border-radius: 8px;">
            <h3 id="form-title">Adicionar Disponibilidade</h3>
            <%-- O id="form-availability" é usado pelo JavaScript para trocar a URL entre /save e /edit --%>
            <form id="form-availability" action="${pageContext.request.contextPath}/autenticado/availability/save" method="POST">
                <input type="hidden" name="id" id="input-id" value="">
                
                <div style="display: flex; gap: 10px; flex-wrap: wrap; justify-content: center;">
                    <select name="dayOfWeek" id="select-dia" required>
                        <option value="1">Segunda</option>
                        <option value="2">Terça</option>
                        <option value="3">Quarta</option>
                        <option value="4">Quinta</option>
                        <option value="5">Sexta</option>
                        <option value="6">Sábado</option>
                        <option value="7">Domingo</option>
                    </select>
                    
                    <input type="time" name="startTime" id="input-inicio" required>
                    <input type="time" name="endTime" id="input-fim" required>
                    
                    <button type="submit" style="background-color: #28a745; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor:pointer;">Confirmar</button>
                    <button type="button" onclick="fecharForm()" style="background-color: #6c757d; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor:pointer;">Cancelar</button>
                </div>
            </form>
        </div>

        <table border="1" style="width: 80%; margin: 0 auto; border-collapse: collapse; text-align: center;">
            <thead>
                <tr style="background-color: #eee;">
                    <th>Dia</th>
                    <th>Horário</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Availability> lista = (List<Availability>) request.getAttribute("schedules");
                    if(lista != null && !lista.isEmpty()) {
                        for(Availability h : lista) { 
                %>
                <tr>
                    <td><%= h.getDayWeek() %></td>
                    <td><%= h.getHourStart() %> - <%= h.getHourEnd() %></td>
                    <td>
                        <form id="form-status-<%= h.getId() %>" action="${pageContext.request.contextPath}/autenticado/availability/toggle" method="POST">
                            <input type="hidden" name="id" value="<%= h.getId() %>">
                            <input type="checkbox" <%= h.isActive() ? "checked" : "" %> onchange="toggleStatus(<%= h.getId() %>)" style="cursor:pointer;">
                        </form>
                    </td>
                    <td>
                        <button onclick="editar(<%= h.getId() %>, '<%= h.getDayWeek().getValue() %>', '<%= h.getHourStart() %>', '<%= h.getHourEnd() %>')" style="cursor:pointer;">Editar</button>
                        <form action="${pageContext.request.contextPath}/autenticado/availability/remove" method="POST" style="display:inline;">
                             <input type="hidden" name="id" value="<%= h.getId() %>">
                             <button type="submit" style="color: red; background: none; border: none; cursor: pointer;" onclick="return confirm('Excluir?')">[Remover]</button>
                        </form>
                    </td>
                </tr>
                <% } } else { %>
                    <tr><td colspan="4">Nenhum horário cadastrado.</td></tr>
                <% } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>