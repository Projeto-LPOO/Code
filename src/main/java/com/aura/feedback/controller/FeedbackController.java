package com.aura.feedback.controller;

import com.aura.feedback.dao.FeedbackDao;
import com.aura.feedback.model.Feedback;
import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.model.Meeting;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
//so vai funcionar se o meetingDao estiver funcional
@WebServlet("/autenticado/feedback")
public class FeedbackController extends BaseController {
    private static final long serialVersionUID = 1L;
    private FeedbackDao feedbackDao = new FeedbackDao();
    private MeetingDao meetingDao = new MeetingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");


        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

     // pega o ID que veio na URL tipo: ?meetingId=1
        String meetingIdStr = request.getParameter("meetingId");
        
        if (meetingIdStr == null || meetingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/autenticado/home");
            return;
        }

        try {
            int meetingId = Integer.parseInt(meetingIdStr);
            Meeting meeting = meetingDao.findById(meetingId);
            if (meeting == null || meeting.getLearner() == null || meeting.getLearner().getId() != user.getId()) {
            	response.sendRedirect(request.getContextPath() + "/autenticado/home");
                return;
            }
            if (feedbackDao.hasFeedback(meetingId)) {
                request.getSession().setAttribute("erroMsg", "Esta aula já foi avaliada por você!");
                response.sendRedirect(request.getContextPath() + "/autenticado/home");
                return;
            }
            forward(request, response, "autenticado/feedback.jsp");

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/autenticado/home");
        }
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);

        try {
            switch (action) {
                case "save" -> registerFeedback(request);
                default -> response.sendError(404);
            }
            response.sendRedirect(request.getContextPath() + "/autenticado/home");
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response); 
        }
    }


    private void registerFeedback(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user =  (User) session.getAttribute("user");


        if (user == null) {
            throw new RuntimeException("Sessão expirada. Por favor, faça login novamente.");
        }

        int meetingId = Integer.parseInt(request.getParameter("meetingId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");


        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("A nota deve ser entre 1 e 5 estrelas.");
        }


        Meeting meeting = meetingDao.findById(meetingId);
        if (meeting == null) {
            throw new IllegalArgumentException("Reunião não encontrada.");
        }

        // validação de permissão se o user logado é o learne dessa meet
        // nao deixa que um aluno avalie a aula do outro via URL
        if (meeting.getLearner() != null && meeting.getLearner().getId() != user.getId()) {
            throw new IllegalArgumentException("Você não tem permissão para avaliar esta reunião.");
        }

        // Validação de duplicidade
        if (feedbackDao.hasFeedback(meetingId)) {
            throw new IllegalArgumentException("Esta reunião já foi avaliada anteriormente.");
        }

        // apenas reunioes done
        if (!"done".equalsIgnoreCase(meeting.getStatus())) {
            throw new IllegalArgumentException("Apenas reuniões finalizadas podem ser avaliadas.");
        }

        // verifica se o teacher existe
        if (meeting.getTeacher() == null) {
            throw new RuntimeException("Erro: Instrutor não identificado para esta reunião.");
        }

        Feedback feedback = new Feedback(
            meetingId, 
            user.getId(), 
            meeting.getTeacher().getId(), 
            rating, 
            comment
        );
        
        feedbackDao.registerFeedback(feedback);
    }
}