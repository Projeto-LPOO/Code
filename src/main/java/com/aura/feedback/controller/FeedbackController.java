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

@WebServlet("/autenticado/feedback")
public class FeedbackController extends BaseController {

    private static final long serialVersionUID = 1L;

    private final FeedbackDao feedbackDao = new FeedbackDao();
    private final MeetingDao meetingDao = new MeetingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String meetingIdStr = request.getParameter("meetingId");
        if (meetingIdStr == null || meetingIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return;
        }

        try {
            int meetingId = Integer.parseInt(meetingIdStr);
            Meeting meeting = meetingDao.findById(meetingId);

            if (meeting == null) {
                session.setAttribute("erroMsg", "Meeting não encontrado.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            String status = meeting.getStatus();

            if ("reported".equalsIgnoreCase(status)) {
                session.setAttribute("erroMsg", "Este meeting foi reportado e não pode ser avaliado.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            if (!"done".equalsIgnoreCase(status)) {
                session.setAttribute("erroMsg", "Apenas meetings concluídos podem ser avaliados.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            boolean isLearner = meeting.getLearner() != null && meeting.getLearner().getId() == user.getId();
            boolean isTeacher = meeting.getTeacher() != null && meeting.getTeacher().getId() == user.getId();

            if (!isLearner && !isTeacher) {
                session.setAttribute("erroMsg", "Você não é participante deste meeting.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            if (feedbackDao.hasFeedbackFromUser(meetingId, user.getId())) {
                session.setAttribute("erroMsg", "Você já avaliou este meeting.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            request.setAttribute("meeting", meeting);
            request.setAttribute("isTeacher", isTeacher);
            request.setAttribute("targetName", isTeacher ? meeting.getLearner().getName()
                    : meeting.getTeacher().getName());

            forward(request, response, "autenticado/feedback.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            registerFeedback(request, user);
            session.setAttribute("successMsg", "Avaliação enviada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }

    private void registerFeedback(HttpServletRequest request, User user) {
        String meetingIdStr = request.getParameter("meetingId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (meetingIdStr == null || ratingStr == null)
            throw new IllegalArgumentException("Parâmetros obrigatórios ausentes.");

        int meetingId = Integer.parseInt(meetingIdStr);
        int rating    = Integer.parseInt(ratingStr);

        if (rating < 1 || rating > 5)
            throw new IllegalArgumentException("A nota deve ser entre 1 e 5 estrelas.");

        Meeting meeting = meetingDao.findById(meetingId);
        if (meeting == null)
            throw new IllegalArgumentException("Meeting não encontrado.");

        String status = meeting.getStatus();

        if ("reported".equalsIgnoreCase(status))
            throw new IllegalArgumentException("Este meeting foi reportado e não pode ser avaliado.");

        if (!"done".equalsIgnoreCase(status))
            throw new IllegalArgumentException("Apenas meetings finalizados podem ser avaliados.");

        boolean isLearner = meeting.getLearner() != null && meeting.getLearner().getId() == user.getId();
        boolean isTeacher = meeting.getTeacher() != null && meeting.getTeacher().getId() == user.getId();

        if (!isLearner && !isTeacher)
            throw new IllegalArgumentException("Você não tem permissão para avaliar este meeting.");

        if (feedbackDao.hasFeedbackFromUser(meetingId, user.getId()))
            throw new IllegalArgumentException("Você já avaliou este meeting.");

        if (meeting.getTeacher() == null)
            throw new RuntimeException("Instrutor não identificado para este meeting.");

        int toUserId = isTeacher ? meeting.getLearner().getId()
                : meeting.getTeacher().getId();

        feedbackDao.registerFeedback(new Feedback(meetingId, user.getId(), toUserId, rating, comment));
    }
}