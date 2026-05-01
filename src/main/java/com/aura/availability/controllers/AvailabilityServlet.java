package com.aura.availability.controllers;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

import com.aura.availability.Dao.AvailabilityDao;
import com.aura.availability.models.Availability;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/autenticado/availability")
public class AvailabilityServlet extends BaseController {
    private static final long serialVersionUID = 1L;
    private AvailabilityDao availabilityDao = new AvailabilityDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // O ID deve vir do objeto User que já está na sua sessão
        findAllAvailability(request, user.getId());
        
        // Caminho da view usando o padrão da sua líder
        forward(request, response, "autenticado/availability.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String action = getAction(request);

        try {
            // O switch agora compara com o que vem da URL (save, edit, remove, etc)
            switch (action) {
                case "save" -> registerAvailability(request);
                case "edit" -> updateAvailability(request);
                case "toggle" -> changeStatus(request);
                case "remove" -> deleteAvailability(request);
                default -> response.sendError(404); // Se a URL não bater com nada
            }
            
            // Após processar, redireciona para a listagem (limpa a URL)
            response.sendRedirect(request.getContextPath() + "/autenticado/availability");
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response); 
        }
    }

    private void findAllAvailability(HttpServletRequest request, int userId) {
        List<Availability> schedules = availabilityDao.findAllAvailability(userId);
        if (schedules != null) {
            schedules.sort((h1, h2) -> {
                int dayComp = h1.getDayWeek().compareTo(h2.getDayWeek());
                return (dayComp == 0) ? h1.getHourStart().compareTo(h2.getHourStart()) : dayComp;
            });
        }
        request.setAttribute("schedules", schedules);
    }

    private void registerAvailability(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        int dayInt = Integer.parseInt(request.getParameter("dayOfWeek"));
        String startText = request.getParameter("startTime");
        String endText = request.getParameter("endTime");

        LocalTime hourStart = formattedHour(startText);
        LocalTime hourEnd = formattedHour(endText);

        validateBusinessRules(user.getId(), DayOfWeek.of(dayInt), hourStart, hourEnd, -1);

        CommercialUser cUser = new CommercialUser();
        cUser.setId(user.getId());
        availabilityDao.registerAvailability(new Availability(cUser, DayOfWeek.of(dayInt), hourStart, hourEnd));
    }

    private void updateAvailability(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        int id = Integer.parseInt(request.getParameter("id"));
        int dayInt = Integer.parseInt(request.getParameter("dayOfWeek"));
        String startText = request.getParameter("startTime");
        String endText = request.getParameter("endTime");

        LocalTime hourStart = formattedHour(startText);
        LocalTime hourEnd = formattedHour(endText);

        validateBusinessRules(user.getId(), DayOfWeek.of(dayInt), hourStart, hourEnd, id);

        CommercialUser cUser = new CommercialUser();
        cUser.setId(user.getId());

        Availability up = new Availability(cUser, DayOfWeek.of(dayInt), hourStart, hourEnd);
        up.setId(id);
        availabilityDao.updateAvailability(up);
    }
   

    private void deleteAvailability(HttpServletRequest request) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            availabilityDao.deleteAvailability(Integer.parseInt(idParam));
        }
    }

    private void changeStatus(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        Availability disp = availabilityDao.findById(id);
        if (disp != null) {
            availabilityDao.changeStatus(id, !disp.isActive());
        }
    }

    // --- MÉTODOS DE APOIO E VALIDAÇÃO ---

    private void validateBusinessRules(int userId, DayOfWeek day, LocalTime start, LocalTime end, int currentId) {
        if (start == null || end == null) throw new IllegalArgumentException("Horário inválido.");
        
        if (start.isAfter(end) || start.equals(end)) {
            throw new IllegalArgumentException("Erro: A hora de início não pode ser maior ou igual ao término.");
        }

        List<Availability> existingSchedules = availabilityDao.findAllAvailability(userId);
        for (Availability existing : existingSchedules) {
            if (existing.getId() != currentId && existing.getDayWeek().equals(day)) {
                if (start.isBefore(existing.getHourEnd()) && end.isAfter(existing.getHourStart())) {
                    throw new IllegalArgumentException("Conflito! Horário já ocupado das " 
                            + existing.getHourStart() + " às " + existing.getHourEnd() + " na " + day);
                }
            }
        }
    }

    private LocalTime formattedHour(String hour) {
        try {
            return LocalTime.parse(hour, DateTimeFormatter.ofPattern("HH:mm"));
        } catch (DateTimeParseException e) {
            return null;
        }
    }
}