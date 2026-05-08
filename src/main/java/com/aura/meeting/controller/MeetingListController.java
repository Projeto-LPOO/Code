/*package com.aura.meeting.controller;

import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Meeting;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class MeetingListController extends BaseController {

    private final MeetingController meetingController = new MeetingController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Meeting> meetings = meetingController.findByUserId(loggedUser.getId());

        Map<Integer, String> typeMap = new LinkedHashMap<>();
        for (Meeting m : meetings) {
            typeMap.put(m.getId(), m instanceof FaceToFaceMeeting ? "PRESENCIAL" : "ONLINE");
        }

        request.setAttribute("meetings", meetings);
        request.setAttribute("tipoMap", typeMap);
        forward(request, response, "autenticado/meetingList.jsp");
    }
}*/