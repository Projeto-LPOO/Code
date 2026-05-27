package com.aura.profile.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.aura.profile.dao.ProfileDao;
import com.aura.profile.models.Profile; // CORRIGIDO: adicionado o 's' em models
import com.aura.user.models.CommercialUser;
import com.aura.feedback.model.Feedback;
import com.aura.feedback.dao.FeedbackDao;

@WebServlet("/autenticado/profile")
public class ProfileController extends HttpServlet {

    private ProfileDao profileDao = new ProfileDao();
    private FeedbackDao feedbackDao = new FeedbackDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        CommercialUser user = (CommercialUser) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // 1. Busca os dados de Bio e Cidade do perfil
        Profile profile = profileDao.findByUserId(user.getId());
        if (profile == null) {
            profile = new Profile();
            profile.setUserId(user.getId());
            profileDao.create(profile);
            profile = profileDao.findByUserId(user.getId());
        }
        request.setAttribute("profile", profile);

        // 2. Busca os feedbacks recebidos pelo usuário
        List<Feedback> feedbacks = feedbackDao.findByToUserId(user.getId());
        request.setAttribute("feedbacks", feedbacks);

        request.getRequestDispatcher("/WEB-INF/views/autenticado/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        CommercialUser user = (CommercialUser) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String bio = request.getParameter("bio");
        String city = request.getParameter("city");

        Profile profile = profileDao.findByUserId(user.getId());

        if (profile == null) {
            profile = new Profile();
            profile.setUserId(user.getId());
            profile.setBio(bio);
            profile.setCity(city);

            profileDao.create(profile);
        } else {
            profile.setBio(bio);
            profile.setCity(city);

            profileDao.update(profile);
        }

        response.sendRedirect(request.getContextPath() + "/autenticado/profile");
    }
}