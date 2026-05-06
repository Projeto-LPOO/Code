<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.meeting.model.Meeting" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Aura - Enviar Feedback</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/feedback.css">
    
</head>
<body>
    <div style="display: block; width: 100%; max-width: 500px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; background: white; box-sizing: border-box;">
        <h2 style="text-align: center;">Avaliar Meeting</h2>
        
        <%-- Exibição de mensagens de erro capturadas pelo catch do Controller --%>
        <% if(request.getAttribute("error") != null) { %>
            <div style="color: red; background: #fee; padding: 10px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #fcc;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>


        <form action="${pageContext.request.contextPath}/autenticado/feedback/save" method="POST">
            <input type="hidden" name="meetingId" value="${param.meetingId}">

            <p style="text-align: center;">Como foi sua experiência na reuniao? <strong>#${param.meetingId}</strong></p>

            <div class="star-rating">
                <input type="radio" id="5-stars" name="rating" value="5" required />
                <label for="5-stars">★</label>
                <input type="radio" id="4-stars" name="rating" value="4" />
                <label for="4-stars">★</label>
                <input type="radio" id="3-stars" name="rating" value="3" />
                <label for="3-stars">★</label>
                <input type="radio" id="2-stars" name="rating" value="2" />
                <label for="2-stars">★</label>
                <input type="radio" id="1-star" name="rating" value="1" />
                <label for="1-star">★</label>
            </div>

            <div style="margin-top: 20px;">
                <label for="comment">Comentário:</label>
                <textarea name="comment" id="comment" rows="4" placeholder="Conte-nos o que achou da aula..." required></textarea>
            </div>

            <div style="margin-top: 20px; display: flex; gap: 10px;">
                <button type="submit" style="flex: 2; background: #4d1896; color: white; border: none; padding: 10px; border-radius: 5px; cursor: pointer; font-weight: bold;">
                    Enviar Avaliação
                </button>
                <a href="${pageContext.request.contextPath}/autenticado/meeting" style="flex: 1; text-align: center; background: #6c757d; color: white; text-decoration: none; padding: 10px; border-radius: 5px;">
                    Voltar
                </a>
            </div>
        </form>
    </div>
</body>
</html>