package com.aura.profile.controllers;

import com.aura.user.dao.UserDao;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.aura.profile.dao.ProfileDao;
import com.aura.profile.models.Profile;
import com.aura.user.models.CommercialUser;
import com.aura.feedback.model.Feedback;
import com.aura.feedback.dao.FeedbackDao;

@WebServlet("/autenticado/profile")
public class ProfileController extends HttpServlet {

    private ProfileDao profileDao = new ProfileDao();
    private FeedbackDao feedbackDao = new FeedbackDao();
    private UserDao userDao = new UserDao();

    // 1. CARREGA A PÁGINA
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

// 1. Tenta pegar o ID da URL
        String idParam = request.getParameter("id");
        int userId = 1; // Valor padrão de segurança


        if (idParam != null && !idParam.isEmpty()) {
            userId = Integer.parseInt(idParam);
        } else {
            // 2. Apenas tenta pegar da sessão se o ID não estiver na URL E a sessão existir
            Long usuarioLogadoId = (Long) request.getSession().getAttribute("usuarioId");
            if (usuarioLogadoId != null) {
                userId = usuarioLogadoId.intValue();
            }
        }
        CommercialUser user = userDao.findById(userId);

// Agora o código continua sem dar erro de null pointer
        Profile profile = profileDao.findByUserId(userId);
        List<Feedback> feedbacks = feedbackDao.findByToUserId(userId);

        request.setAttribute("profile", profile);
        request.setAttribute("profileId", userId);

        // Calcula a média das notas dinamicamente
        double somatorio = 0.0;
        for (Feedback fb : feedbacks) {
            CommercialUser commercialUser = userDao.findById(fb.getFromUserId());
            fb.setFromUserName(commercialUser.getName());
            somatorio += fb.getRating();
        }
        double media = feedbacks.isEmpty() ? 0.0 : somatorio / feedbacks.size();

        // Envia as variáveis para o JSP
        request.setAttribute("profile", profile);
        request.setAttribute("user", user);
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("averageRating", String.format(java.util.Locale.US, "%.1f", media));
        request.setAttribute("totalReviews", feedbacks.size());
        // Encaminha para a tela correspondente
        request.getRequestDispatcher("/WEB-INF/views/autenticado/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");
        try {
            String bio = request.getParameter("bio");
            profileDao.updateBio(loggedUser.getId(), bio);
            response.getWriter().write("{\"success\": true, \"message\": \"Biografia atualizada com sucesso!\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Erro interno do servidor ao salvar: " + e.getMessage() + "\"}");
        }
    }
}

