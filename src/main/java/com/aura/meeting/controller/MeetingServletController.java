package com.aura.meeting.controller;

import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.OnlineMeeting;
import com.aura.shared.controllers.BaseController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

public class MeetingServletController extends BaseController {

    private final MeetingController meetingController = new MeetingController();
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {
            case "detail" -> detail(request, response);
            default -> listAll(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        try {
            switch (action) {
                case "save"   -> save(request);
                case "update" -> update(request);
                case "delete" -> delete(request);
                default -> response.sendError(404);
            }
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listAll(request, response);
        } catch (RuntimeException e) {
            request.setAttribute("error", "Erro interno. Tente novamente.");
            listAll(request, response);
        }
    }

    private void listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> meetings = meetingController.getMeetings();
        request.setAttribute("meetings", meetings);
        forward(request, response, "autenticado/meetingList.jsp");
    }

    private void detail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
            return;
        }

        Meeting meeting = meetingController.getById(Integer.parseInt(idParam));
        request.setAttribute("meeting", meeting);
        forward(request, response, "autenticado/meetingDetail.jsp");
    }

    private void save(HttpServletRequest request) {
        String tipo      = request.getParameter("tipo");
        String descricao = request.getParameter("descricao");
        String dataStr   = request.getParameter("dataHora");

        LocalDateTime dataHora = parseDateTime(dataStr);

        Meeting meeting;

        if ("presencial".equalsIgnoreCase(tipo)) {
            FaceToFaceMeeting ftf = new FaceToFaceMeeting();
            ftf.setDescription(descricao);
            ftf.setDayTime(dataHora);

            Location loc = new Location();
            loc.setCity(request.getParameter("cidade"));
            loc.setNeighborhood(request.getParameter("bairro"));
            loc.setStreet(request.getParameter("rua"));
            loc.setHouseNumber(Integer.parseInt(request.getParameter("numero")));
            loc.setReferencePoint(request.getParameter("referencia"));
            ftf.setLocation(loc);

            String instrucoes = request.getParameter("instrucoes");
            ftf.setInstructions(instrucoes != null && instrucoes.trim().isEmpty() ? null : instrucoes);

            meeting = ftf;
        } else {
            OnlineMeeting om = new OnlineMeeting();
            om.setDescription(descricao);
            om.setDayTime(dataHora);
            om.setLinkPlataform(request.getParameter("link"));
            meeting = om;
        }

        meetingController.registerMeeting(meeting);
    }

    private void update(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        Meeting meeting = meetingController.getById(id);

        if (meeting == null) {
            throw new IllegalArgumentException("Meeting não encontrado.");
        }

        meeting.setDescription(request.getParameter("descricao"));
        meeting.setDayTime(parseDateTime(request.getParameter("dataHora")));
        meeting.setStatus(request.getParameter("status"));

        if (meeting instanceof FaceToFaceMeeting ftf) {
            Location loc = ftf.getLocation();
            loc.setCity(request.getParameter("cidade"));
            loc.setNeighborhood(request.getParameter("bairro"));
            loc.setStreet(request.getParameter("rua"));
            loc.setHouseNumber(Integer.parseInt(request.getParameter("numero")));
            loc.setReferencePoint(request.getParameter("referencia"));
        }

        meetingController.updateMeeting(meeting);
    }

    private void delete(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        meetingController.deleteMeeting(id);
    }

    private LocalDateTime parseDateTime(String dataStr) {
        try {
            return LocalDateTime.parse(dataStr, FORMATTER);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Formato de data inválido. Use dd/MM/yyyy HH:mm");
        }
    }
}