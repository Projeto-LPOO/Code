/*package com.aura.meeting.controller;

import com.aura.shared.controllers.BaseController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class MeetingDeleteController extends BaseController {

    private final MeetingController meetingController = new MeetingController();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        try {
            if (idParam == null || idParam.trim().isEmpty())
                throw new IllegalArgumentException("ID do meeting é obrigatório.");

            int id = Integer.parseInt(idParam);

            if (meetingController.findById(id) == null)
                throw new IllegalArgumentException("Meeting não encontrado.");

            meetingController.delete(id);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }
}*/