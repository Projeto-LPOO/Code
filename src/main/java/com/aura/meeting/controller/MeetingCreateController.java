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

public class MeetingCreateController extends BaseController {

    private final MeetingController meetingController = new MeetingController();
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forward(request, response, "autenticado/meetingRegister.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tipo = request.getParameter("tipo");
        String descricao = request.getParameter("descricao");
        String dataStr = request.getParameter("dataHora");

        try {
            // Validações de campos comuns
            if (descricao == null || descricao.trim().isEmpty()) {
                throw new IllegalArgumentException("Descrição é obrigatória.");
            }

            if (dataStr == null || dataStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Data e hora são obrigatórias.");
            }

            LocalDateTime dataHora = parseDateTime(dataStr);

            if (dataHora.isBefore(LocalDateTime.now())) {
                throw new IllegalArgumentException("A data do meeting não pode ser no passado.");
            }

            Meeting meeting;

            if ("presencial".equalsIgnoreCase(tipo)) {
                String cidade = request.getParameter("cidade");
                String rua = request.getParameter("rua");
                String bairro = request.getParameter("bairro");
                String numStr = request.getParameter("numero");

                if (cidade == null || cidade.trim().isEmpty()) {
                    throw new IllegalArgumentException("Cidade é obrigatória para meeting presencial.");
                }
                if (rua == null || rua.trim().isEmpty()) {
                    throw new IllegalArgumentException("Rua é obrigatória para meeting presencial.");
                }
                if (numStr == null || numStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Número é obrigatório para meeting presencial.");
                }

                int numero;
                try {
                    numero = Integer.parseInt(numStr);
                    if (numero <= 0) throw new NumberFormatException();
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Número do endereço inválido.");
                }

                FaceToFaceMeeting ftf = new FaceToFaceMeeting();
                ftf.setDescription(descricao.trim());
                ftf.setDayTime(dataHora);

                Location loc = new Location();
                loc.setCity(cidade.trim());
                loc.setNeighborhood(bairro != null ? bairro.trim() : "");
                loc.setStreet(rua.trim());
                loc.setHouseNumber(numero);
                loc.setReferencePoint(request.getParameter("referencia"));
                ftf.setLocation(loc);

                String instrucoes = request.getParameter("instrucoes");
                ftf.setInstructions(instrucoes != null && !instrucoes.trim().isEmpty() ? instrucoes.trim() : null);

                meeting = ftf;

            } else {
                String link = request.getParameter("link");

                if (link == null || link.trim().isEmpty()) {
                    throw new IllegalArgumentException("Link/Plataforma é obrigatório para meeting online.");
                }

                OnlineMeeting om = new OnlineMeeting();
                om.setDescription(descricao.trim());
                om.setDayTime(dataHora);
                om.setLinkPlataform(link.trim());
                meeting = om;
            }

            meetingController.registerMeeting(meeting);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting/register");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("tipo", tipo);
            request.setAttribute("descricao", descricao);
            request.setAttribute("dataHora",  dataStr);
            forward(request, response, "autenticado/meetingRegister.jsp");
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