<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aura.availability.Availability" %>

<!DOCTYPE html>
<html>
<head>
    <title>Aura - Disponibilidade</title>
    <link rel="stylesheet" href="css/home.css">
    <script>
        function showNovoForm() {
            document.getElementById('form-container').style.display = 'block';
            document.getElementById('form-title').innerText = 'Adicionar Disponibilidade';
            document.getElementById('input-id').value = '';
            document.getElementById('acao-form').value = 'salvar';
        }

        function editar(id, dia, inicio, fim) {
            document.getElementById('form-container').style.display = 'block';
            document.getElementById('form-title').innerText = 'Editar Disponibilidade';
            document.getElementById('input-id').value = id;
            document.getElementById('select-dia').value = dia;
            document.getElementById('input-inicio').value = inicio;
            document.getElementById('input-fim').value = fim;
            document.getElementById('acao-form').value = 'editar';
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
<main>
    <section class="card-bv">
        <h2>Meus Horários</h2>

        <%-- BLOCO DE MENSAGEM DE ERRO --%>
        <% if(request.getAttribute("erro") != null) { %>
            <div style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin: 10px auto 20px auto; border: 1px solid #f5c6cb; width: 80%; text-align: center;">
                <strong>Atenção:</strong> <%= request.getAttribute("erro") %>
            </div>
        <% } %>

        <button onclick="showNovoForm()" style="padding: 10px; margin-bottom: 20px; cursor:pointer;">
            + Adicionar Disponibilidade
        </button>

        <div id="form-container" style="display:none; border: 1px solid #ccc; padding: 20px; margin-bottom: 20px; background: #f9f9f9; border-radius: 8px;">
            <h3 id="form-title">Adicionar Disponibilidade</h3>
            <form action="AvailabilityServlet" method="POST">
                <input type="hidden" name="acao" id="acao-form" value="salvar">
                <input type="hidden" name="id" id="input-id" value="">
                
                <div style="display: flex; gap: 10px; flex-wrap: wrap; justify-content: center;">
                    <select name="diaSemana" id="select-dia" required>
                        <option value="1">Segunda</option>
                        <option value="2">Terça</option>
                        <option value="3">Quarta</option>
                        <option value="4">Quinta</option>
                        <option value="5">Sexta</option>
                        <option value="6">Sábado</option>
                        <option value="7">Domingo</option>
                    </select>
                    <input type="time" name="inicio" id="input-inicio" required>
                    <input type="time" name="fim" id="input-fim" required>
                    
                    <button type="submit" style="background-color: #28a745; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor:pointer;">Salvar</button>
                    <button type="button" onclick="fecharForm()" style="background-color: #6c757d; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor:pointer;">Cancelar</button>
                </div>
            </form>
        </div>

        <%-- TABELA CENTRALIZADA --%>
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
                    List<Availability> lista = (List<Availability>) request.getAttribute("horarios");
                    if(lista != null && !lista.isEmpty()) {
                        for(Availability h : lista) { 
                %>
                <tr>
                    <td><%= h.getDayWeek() %></td>
                    <td><%= h.getHourStart() %> - <%= h.getHourEnd() %></td>
                    <td>
                        <form id="form-status-<%= h.getId() %>" action="AvailabilityServlet" method="POST">
                            <input type="hidden" name="acao" value="alternar">
                            <input type="hidden" name="id" value="<%= h.getId() %>">
                            <input type="checkbox" <%= h.isActive() ? "checked" : "" %> onchange="toggleStatus(<%= h.getId() %>)" style="cursor:pointer;">
                        </form>
                    </td>
                    <td>
                        <button onclick="editar(<%= h.getId() %>, '<%= h.getDayWeek().getValue() %>', '<%= h.getHourStart() %>', '<%= h.getHourEnd() %>')" style="cursor:pointer;">Editar</button>
                        
                        <a href="AvailabilityServlet?acao=remover&id=<%= h.getId() %>" 
                           style="color: red; margin-left: 10px; font-size: 0.9em; text-decoration: none;" 
                           onclick="return confirm('Excluir este horário?')">[Remover]</a>
                    </td>
                </tr>
                <%      } 
                    } else { %>
                    <tr><td colspan="4">Nenhum horário cadastrado.</td></tr>
                <%  } %>
            </tbody>
        </table>
        <br>
        <a href="autenticado/home.jsp" style="display: inline-block; margin-top: 15px;">Voltar ao Início</a>
    </section>
</main>
</body>
</html>