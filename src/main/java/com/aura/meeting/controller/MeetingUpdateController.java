package com.aura.meeting.controller;

import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;
import com.aura.shared.controllers.BaseController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class MeetingUpdateController extends BaseController {

    private final MeetingController meetingController = new MeetingController();
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String descricao = request.getParameter("descricao");
        String dataStr = request.getParameter("dataHora");
        String status = request.getParameter("status");

        try {
            if (idParam == null || idParam.trim().isEmpty())
                throw new IllegalArgumentException("ID do meeting é obrigatório.");

            int id = Integer.parseInt(idParam);
            Meeting meeting = meetingController.findById(id);

            if (meeting == null)
                throw new IllegalArgumentException("Meeting não encontrado.");
            if (descricao == null || descricao.trim().isEmpty())
                throw new IllegalArgumentException("Descrição é obrigatória.");
            if (dataStr == null || dataStr.trim().isEmpty())
                throw new IllegalArgumentException("Data e hora são obrigatórias.");

            meeting.setDescription(descricao.trim());
            meeting.setDayTime(parseDateTime(dataStr));
            meeting.setStatus(status);

            if (meeting instanceof FaceToFaceMeeting ftf) {
                String cidade = request.getParameter("cidade");
                String rua = request.getParameter("rua");
                String numStr = request.getParameter("numero");

                if (cidade == null || cidade.trim().isEmpty())
                    throw new IllegalArgumentException("Cidade é obrigatória.");
                if (rua == null || rua.trim().isEmpty())
                    throw new IllegalArgumentException("Rua é obrigatória.");

                int numero;
                try {
                    numero = Integer.parseInt(numStr);
                    if (numero <= 0) throw new NumberFormatException();
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Número do endereço inválido.");
                }

                Location loc = ftf.getLocation();
                if (loc == null) loc = new Location();
                loc.setCity(cidade.trim());
                loc.setNeighborhood(request.getParameter("bairro"));
                loc.setStreet(rua.trim());
                loc.setHouseNumber(numero);
                loc.setReferencePoint(request.getParameter("referencia"));
                ftf.setLocation(loc);
            }

            meetingController.update(meeting);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }

    private LocalDateTime parseDateTime(String str) {
        try {
            return LocalDateTime.parse(str, FORMATTER);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Formato de data inválido. Use dd/MM/yyyy HH:mm.");
        }
    }
}