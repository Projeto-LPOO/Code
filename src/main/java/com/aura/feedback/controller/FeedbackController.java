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
    private final MeetingDao  meetingDao  = new MeetingDao();

    // GET — exibe o formulário de feedback para aluno OU professor
    // (TESTE) URL esperada: /autenticado/feedback?meetingId=X
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
            int     meetingId = Integer.parseInt(meetingIdStr);
            Meeting meeting   = meetingDao.findById(meetingId);

            // meeting precisa existir e estar concluído
            if (meeting == null || !"done".equalsIgnoreCase(meeting.getStatus())) {
                session.setAttribute("erroMsg", "Apenas meetings concluídos podem ser avaliados.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            boolean isLearner = meeting.getLearner() != null
                    && meeting.getLearner().getId() == user.getId();
            boolean isTeacher = meeting.getTeacher() != null
                    && meeting.getTeacher().getId() == user.getId();

            // usuário precisa ser participante
            if (!isLearner && !isTeacher) {
                session.setAttribute("erroMsg", "Você não é participante deste meeting.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            // verifica se este usuário já avaliou
            if (feedbackDao.hasFeedbackFromUser(meetingId, user.getId())) {
                session.setAttribute("erroMsg", "Você já avaliou este meeting.");
                response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
                return;
            }

            // disponibiliza dados para a view
            request.setAttribute("meeting",   meeting);
            request.setAttribute("isTeacher", isTeacher);
            // quem o usuário vai avaliar
            request.setAttribute("targetName",
                    isTeacher ? meeting.getLearner().getName()
                            : meeting.getTeacher().getName());

            forward(request, response, "autenticado/feedback.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }


    // POST — salva o feedback (aluno avalia professor ou vice-versa)
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
            // devolve ao formulário com a mensagem de erro
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }


    // Lógica de negócio — salva feedback respeitando papéis
    private void registerFeedback(HttpServletRequest request, User user) {
        String meetingIdStr = request.getParameter("meetingId");
        String ratingStr    = request.getParameter("rating");
        String comment      = request.getParameter("comment");

        if (meetingIdStr == null || ratingStr == null)
            throw new IllegalArgumentException("Parâmetros obrigatórios ausentes.");

        int meetingId = Integer.parseInt(meetingIdStr);
        int rating    = Integer.parseInt(ratingStr);

        if (rating < 1 || rating > 5)
            throw new IllegalArgumentException("A nota deve ser entre 1 e 5 estrelas.");

        Meeting meeting = meetingDao.findById(meetingId);
        if (meeting == null)
            throw new IllegalArgumentException("Meeting não encontrado.");

        if (!"done".equalsIgnoreCase(meeting.getStatus()))
            throw new IllegalArgumentException("Apenas meetings finalizados podem ser avaliados.");

        boolean isLearner = meeting.getLearner() != null
                && meeting.getLearner().getId() == user.getId();
        boolean isTeacher = meeting.getTeacher() != null
                && meeting.getTeacher().getId() == user.getId();

        if (!isLearner && !isTeacher)
            throw new IllegalArgumentException("Você não tem permissão para avaliar este meeting.");

        if (feedbackDao.hasFeedbackFromUser(meetingId, user.getId()))
            throw new IllegalArgumentException("Você já avaliou este meeting.");

        // quem recebe o feedback: se sou aluno, avalia professor — e vice-versa
        int toUserId = isTeacher
                ? meeting.getLearner().getId()
                : meeting.getTeacher().getId();

        Feedback feedback = new Feedback(meetingId, user.getId(), toUserId, rating, comment);
        feedbackDao.registerFeedback(feedback);
    }
}