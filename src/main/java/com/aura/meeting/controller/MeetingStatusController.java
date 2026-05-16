package com.aura.meeting.controller;

import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class MeetingStatusController extends BaseController {

    private final MeetingController meetingController = new MeetingController();

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
            meetingController.updateStatus(meetingId, status.trim(), loggedUser.getId());

            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("statusError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }
}