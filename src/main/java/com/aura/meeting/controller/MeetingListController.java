package com.aura.meeting.controller;

import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Meeting;
import com.aura.shared.controllers.BaseController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class MeetingListController extends BaseController {

    private final MeetingDao meetingDao = new MeetingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Meeting> meetings = meetingDao.findAll();

        // EL não suporta instanceof — resolvemos aqui no controller
        // Mapa de id -> "PRESENCIAL" ou "ONLINE" para o JSP consumir
        Map<Integer, String> tipoMap = new LinkedHashMap<>();
        for (Meeting m : meetings) {
            tipoMap.put(m.getId(), m instanceof FaceToFaceMeeting ? "PRESENCIAL" : "ONLINE");
        }

        request.setAttribute("meetings", meetings);
        request.setAttribute("tipoMap", tipoMap);
        forward(request, response, "autenticado/meetingList.jsp");
    }
}