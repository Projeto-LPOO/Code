package com.aura.meeting.controller;

import com.aura.meeting.model.Meeting;
import com.aura.notification.controller.NotificationWebController;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class MeetingStatusController extends BaseController {

    private final MeetingController meetingController = new MeetingController();
    private final NotificationWebController notificationController = new NotificationWebController();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        String status = request.getParameter("status");

        try {
            if (idParam == null || idParam.trim().isEmpty())
                throw new IllegalArgumentException("ID do meeting é obrigatório.");
            if (status == null || status.trim().isEmpty())
                throw new IllegalArgumentException("Status é obrigatório.");

            int meetingId = Integer.parseInt(idParam);
            Meeting m = meetingController.findById(meetingId);

            meetingController.updateStatus(meetingId, status.trim(), loggedUser.getId());

            String ctx = request.getContextPath();
            switch (status.trim()) {
                case "confirmed" ->
                        notificationController.onMeetingConfirmed(
                                m.getLearner().getId(), m.getTeacher().getName(), m.getDescription(), ctx);
                case "cancelled_by_teacher" ->
                        notificationController.onMeetingCancelledByTeacher(
                                m.getLearner().getId(), m.getTeacher().getName(), m.getDescription(), ctx);
                case "cancelled" -> {
                    boolean actorIsTeacher = m.getTeacher().getId() == loggedUser.getId();
                    int targetId   = actorIsTeacher ? m.getLearner().getId() : m.getTeacher().getId();
                    String actor   = actorIsTeacher
                            ? "O professor " + m.getTeacher().getName()
                            : "O aluno " + m.getLearner().getName();
                    notificationController.onMeetingCancelled(targetId, actor, m.getDescription(), ctx);
                }
                case "done" ->
                        notificationController.onMeetingDone(
                                m.getLearner().getId(), m.getTeacher().getName(), m.getDescription(), ctx);
            }

            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (RuntimeException e) {
            Throwable cause = (e.getCause() != null) ? e.getCause() : e;
            request.getSession().setAttribute("statusError", cause.getMessage());
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }
}