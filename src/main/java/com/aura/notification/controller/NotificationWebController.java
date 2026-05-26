package com.aura.notification.controller;

import com.aura.notification.dao.NotificationDao;
import com.aura.notification.model.Notification;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class NotificationWebController extends BaseController {

    private final NotificationDao dao = new NotificationDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) return;

        String action = getAction(req);

        switch (action) {
            case "go" -> handleGo(req, res, user);
            case "read-all" -> handleReadAll(res, user);
            default -> showList(req, res, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) return;

        String action = getAction(req);

        if (action.equals("read")) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isBlank())
                dao.markAsRead(Integer.parseInt(idParam), user.getId());
        }

        res.sendRedirect(req.getContextPath() + "/autenticado/notification");
    }

    private void showList(HttpServletRequest req, HttpServletResponse res, User user)
            throws ServletException, IOException {
        req.setAttribute("notifications", dao.findByUserId(user.getId()));
        req.setAttribute("unreadCount", dao.countUnread(user.getId()));
        forward(req, res, "autenticado/notificationList.jsp");
    }

    // marca como lida e redireciona para a url da notificação
    private void handleGo(HttpServletRequest req, HttpServletResponse res, User user)
            throws IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/autenticado/notification");
            return;
        }
        int id = Integer.parseInt(idParam);
        Notification n = dao.findById(id, user.getId());
        dao.markAsRead(id, user.getId());
        String url = (n != null) ? n.getRedirectUrl() : req.getContextPath() + "/autenticado/meeting";
        res.sendRedirect(url);
    }

    private void handleReadAll(HttpServletResponse res, User user) throws IOException {
        dao.markAllAsRead(user.getId());
        res.setStatus(200);
    }

    // chamado por MeetingCreateController após registrar o meeting
    public void onMeetingPending(int teacherId, String teacherName, String learnerName,
                                 String description, String contextPath) {
        Notification n = new Notification();
        n.setUserId(teacherId);
        n.setType("MEETING_PENDING");
        n.setTitle("Novo pedido de meeting");
        n.setMessage("O aluno " + learnerName + " solicitou um meeting com você: \""
                + description + "\". Acesse Meetings para confirmar ou recusar.");
        n.setRedirectUrl(contextPath + "/autenticado/meeting");
        dao.create(n);
    }

    // chamado por MeetingStatusController ao confirmar
    public void onMeetingConfirmed(int learnerId, String teacherName,
                                   String description, String contextPath) {
        Notification n = new Notification();
        n.setUserId(learnerId);
        n.setType("MEETING_CONFIRMED");
        n.setTitle("Meeting confirmado");
        n.setMessage("O professor " + teacherName + " confirmou seu meeting: \""
                + description + "\".");
        n.setRedirectUrl(contextPath + "/autenticado/meeting");
        dao.create(n);
    }

    // chamado por MeetingStatusController ao recusar
    public void onMeetingCancelledByTeacher(int learnerId, String teacherName,
                                            String description, String contextPath) {
        Notification n = new Notification();
        n.setUserId(learnerId);
        n.setType("MEETING_CANCELLED_BY_TEACHER");
        n.setTitle("Meeting recusado pelo professor");
        n.setMessage("O professor " + teacherName + " recusou o meeting: \""
                + description + "\".");
        n.setRedirectUrl(contextPath + "/autenticado/meeting");
        dao.create(n);
    }

    // chamado por MeetingStatusController ao cancelar
    public void onMeetingCancelled(int targetUserId, String actorLabel,
                                   String description, String contextPath) {
        Notification n = new Notification();
        n.setUserId(targetUserId);
        n.setType("MEETING_CANCELLED");
        n.setTitle("Meeting cancelado");
        n.setMessage(actorLabel + " cancelou o meeting: \"" + description + "\".");
        n.setRedirectUrl(contextPath + "/autenticado/meeting");
        dao.create(n);
    }

    // chamado por MeetingStatusController ao concluir
    public void onMeetingDone(int learnerId, String teacherName,
                              String description, String contextPath) {
        Notification n = new Notification();
        n.setUserId(learnerId);
        n.setType("MEETING_DONE");
        n.setTitle("Meeting concluído");
        n.setMessage("O professor " + teacherName + " marcou o meeting \""
                + description + "\" como concluído. Não esqueça de avaliar!");
        n.setRedirectUrl(contextPath + "/autenticado/meeting");
        dao.create(n);
    }

    // chamado por MeetingReportController ao reportar (sem uso)
    public void onMeetingReported(int teacherId, String learnerName,
                                  String description, String contextPath) {
        Notification n = new Notification();
        n.setUserId(teacherId);
        n.setType("MEETING_REPORTED");
        n.setTitle("Meeting reportado");
        n.setMessage("O aluno " + learnerName + " reportou o meeting: \""
                + description + "\".");
        n.setRedirectUrl(contextPath + "/autenticado/meeting");
        dao.create(n);
    }

    private User getLoggedUser(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return user;
    }
}