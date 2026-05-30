package com.aura.meeting.controller;

import com.aura.feedback.dao.FeedbackDao;
import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.dao.ReportDao;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.ReportCategory;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/autenticado/meeting/report")
public class MeetingReportController extends BaseController {

    private static final long serialVersionUID = 1L;

    private final MeetingDao meetingDao = new MeetingDao();
    private final ReportDao reportDao = new ReportDao();
    private final FeedbackDao feedbackDao = new FeedbackDao();

    // GET — exibe formulário de report
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedUser(request, response);
        if (user == null) return;

        Meeting meeting = resolveMeeting(request, response, user);
        if (meeting == null) return;

        request.setAttribute("meeting", meeting);
        forward(request, response, "autenticado/meetingReport.jsp");
    }

    // POST — salva o report e atualiza status do meeting para 'reported'
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedUser(request, response);
        if (user == null) return;

        HttpSession session = request.getSession(false);

        try {
            Meeting meeting = resolveMeeting(request, response, user);
            if (meeting == null) return;

            ReportCategory reportCategory = ReportCategory.valueOf(request.getParameter("category"));
            if(reportCategory == null) return;

            String description = request.getParameter("description");

           reportDao.registerReport(meeting.getId(), user.getId(), reportCategory, description);

            // atualiza status para 'reported' para bloquear novas avaliações
            meetingDao.updateStatus(meeting.getId(), "reported");

            session.setAttribute("successMsg", "Meeting reportado com sucesso. Nossa equipe irá analisá-lo.");
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }

    // resolve e valida o meeting para GET e POST
    private Meeting resolveMeeting(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        String meetingIdStr = request.getParameter("meetingId");

        if (meetingIdStr == null || meetingIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return null;
        }

        int meetingId = Integer.parseInt(meetingIdStr);
        Meeting meeting = meetingDao.findById(meetingId);

        if (meeting == null) {
            session.setAttribute("erroMsg", "Meeting não encontrado.");
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return null;
        }

        boolean isDone     = "done".equalsIgnoreCase(meeting.getStatus());
        boolean isReported = "reported".equalsIgnoreCase(meeting.getStatus());

        // só permite reportar meetings concluídos ou já reportados por outro participante
        if (!isDone && !isReported) {
            session.setAttribute("erroMsg", "Apenas meetings concluídos podem ser reportados.");
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return null;
        }

        boolean isParticipant = (meeting.getLearner() != null && meeting.getLearner().getId() == user.getId())
                || (meeting.getTeacher() != null && meeting.getTeacher().getId() == user.getId());

        if (!isParticipant) {
            session.setAttribute("erroMsg", "Você não é participante deste meeting.");
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return null;
        }

        if (reportDao.hasReportFromUser(meetingId, user.getId())) {
            session.setAttribute("erroMsg", "Você já reportou este meeting.");
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return null;
        }

        // um meeting que possui feedback pode ser reportado,
        // mas um meeting reportado bloqueia novas avaliações (tratado no FeedbackController)
        return meeting;
    }

    private User getLoggedUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return user;
    }
}