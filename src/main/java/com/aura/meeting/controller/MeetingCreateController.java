package com.aura.meeting.controller;

import com.aura.category.Category;
import com.aura.category.CategoryDao;
import com.aura.interest.dao.InterestDao;
import com.aura.interest.model.Interest;
import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.OnlineMeeting;
import com.aura.shared.controllers.BaseController;
import com.aura.user.dao.UserDao;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.Learner;
import com.aura.user.models.Teacher;
import com.aura.user.models.User;
import com.google.gson.Gson;
import com.aura.availability.dao.AvailabilityDao;
import com.aura.availability.models.Availability;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.stream.Collectors;

public class MeetingCreateController extends BaseController {

    private final MeetingController meetingController = new MeetingController();
    private final CategoryDao categoryDao = new CategoryDao();
    private final InterestDao interestDao = new InterestDao();
    private final UserDao userDao = new UserDao();
    private final Gson gson = new Gson();

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "mentorCategories" -> fetchCategoriesOfMentor(request, response);
            case "mentorInterests"  -> fetchInterestsOfMentorByCategory(request, response);
            case "mentorSlots" -> fetchAvailableSlotsOfMentor(request, response);
            default                 -> showForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String meetingType     = request.getParameter("tipo");
        String description     = request.getParameter("descricao");
        String dateStr         = request.getParameter("dataHora");
        String teacherIdParam  = request.getParameter("teacherId");
        String interestIdParam = request.getParameter("interestId");

        try {
            if (description == null || description.trim().isEmpty())
                throw new IllegalArgumentException("Descrição é obrigatória.");
            if (dateStr == null || dateStr.trim().isEmpty())
                throw new IllegalArgumentException("Data e hora são obrigatórias.");

            LocalDateTime scheduledAt = parseDateTime(dateStr);

            if (scheduledAt.isBefore(LocalDateTime.now()))
                throw new IllegalArgumentException("A data do meeting não pode ser no passado.");

            if (teacherIdParam == null || teacherIdParam.trim().isEmpty())
                throw new IllegalArgumentException("Selecione um professor.");

            int teacherId = Integer.parseInt(teacherIdParam);
            CommercialUser teacherUser = userDao.findByIdWithInterests(teacherId);
            if (teacherUser == null)
                throw new IllegalArgumentException("Professor não encontrado.");

            Learner learner = new Learner();
            learner.setId(loggedUser.getId());

            Teacher teacher = new Teacher();
            teacher.setId(teacherUser.getId());
            teacher.setName(teacherUser.getName());

            Meeting meeting;

            if ("presencial".equalsIgnoreCase(meetingType)) {
                String city         = request.getParameter("cidade");
                String street       = request.getParameter("rua");
                String neighborhood = request.getParameter("bairro");
                String numberStr    = request.getParameter("numero");

                if (city == null || city.trim().isEmpty())
                    throw new IllegalArgumentException("Cidade é obrigatória para meeting presencial.");
                if (street == null || street.trim().isEmpty())
                    throw new IllegalArgumentException("Rua é obrigatória para meeting presencial.");
                if (numberStr == null || numberStr.trim().isEmpty())
                    throw new IllegalArgumentException("Número é obrigatório para meeting presencial.");

                int houseNumber;
                try {
                    houseNumber = Integer.parseInt(numberStr);
                    if (houseNumber <= 0) throw new NumberFormatException();
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Número do endereço inválido.");
                }

                FaceToFaceMeeting ftf = new FaceToFaceMeeting();
                ftf.setDescription(description.trim());
                ftf.setDayTime(scheduledAt);
                ftf.setLearner(learner);
                ftf.setTeacher(teacher);

                Location loc = new Location();
                loc.setCity(city.trim());
                loc.setNeighborhood(neighborhood != null ? neighborhood.trim() : "");
                loc.setStreet(street.trim());
                loc.setHouseNumber(houseNumber);
                loc.setReferencePoint(request.getParameter("referencia"));
                ftf.setLocation(loc);

                String instructions = request.getParameter("instrucoes");
                ftf.setInstructions(instructions != null && !instructions.trim().isEmpty() ? instructions.trim() : null);

                meeting = ftf;
            } else {
                String link = request.getParameter("link");
                if (link == null || link.trim().isEmpty())
                    throw new IllegalArgumentException("Link/Plataforma é obrigatório para meeting online.");

                OnlineMeeting om = new OnlineMeeting();
                om.setDescription(description.trim());
                om.setDayTime(scheduledAt);
                om.setLearner(learner);
                om.setTeacher(teacher);
                om.setLinkPlataform(link.trim());
                meeting = om;
            }

            if (interestIdParam != null && !interestIdParam.trim().isEmpty()) {
                try {
                    int interestId = Integer.parseInt(interestIdParam);
                    Interest interest = interestDao.findById(interestId);
                    if (interest != null)
                        meeting.setCategory(interest.getCategory());
                } catch (NumberFormatException ignored) {}
            }

            meetingController.register(meeting);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("tipo", meetingType);
            request.setAttribute("descricao", description);
            request.setAttribute("dataHora", dateStr);
            request.setAttribute("preselectedTeacherId", teacherIdParam);
            showForm(request, response);
        }
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String teacherIdParam = request.getParameter("teacherId");
        if (teacherIdParam == null)
            teacherIdParam = (String) request.getAttribute("preselectedTeacherId");

        if (teacherIdParam != null && !teacherIdParam.trim().isEmpty()) {
            try {
                int teacherId = Integer.parseInt(teacherIdParam);
                CommercialUser mentor = userDao.findByIdWithInterests(teacherId);
                if (mentor != null) {
                    request.setAttribute("mentor", mentor);
                    request.setAttribute("preselectedTeacherId", teacherId);

                    List<Category> mentorCategories = mentor.getInterests().stream()
                            .map(Interest::getCategory)
                            .filter(c -> c != null)
                            .distinct()
                            .collect(Collectors.toList());
                    request.setAttribute("mentorCategories", mentorCategories);
                }
            } catch (NumberFormatException ignored) {}
        }

        forward(request, response, "autenticado/meetingRegister.jsp");
    }

    private void fetchCategoriesOfMentor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String teacherIdParam = request.getParameter("teacherId");
        try {
            int teacherId = Integer.parseInt(teacherIdParam);
            CommercialUser mentor = userDao.findByIdWithInterests(teacherId);
            if (mentor == null) {
                response.setStatus(404);
                return;
            }

            List<Category> categories = mentor.getInterests().stream()
                    .map(Interest::getCategory)
                    .filter(c -> c != null)
                    .distinct()
                    .collect(Collectors.toList());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(categories));

        } catch (Exception e) {
            response.setStatus(400);
        }
    }

    private void fetchInterestsOfMentorByCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String teacherIdParam  = request.getParameter("teacherId");
        String categoryIdParam = request.getParameter("categoryId");
        try {
            int teacherId  = Integer.parseInt(teacherIdParam);
            int categoryId = Integer.parseInt(categoryIdParam);

            CommercialUser mentor = userDao.findByIdWithInterests(teacherId);
            if (mentor == null) {
                response.setStatus(404);
                return;
            }

            List<Interest> filtered = mentor.getInterests().stream()
                    .filter(i -> i.getCategory() != null && i.getCategory().getId() == categoryId)
                    .collect(Collectors.toList());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(filtered));

        } catch (Exception e) {
            response.setStatus(400);
        }
    }

    private LocalDateTime parseDateTime(String str) {
        try {
            return LocalDateTime.parse(str, FORMATTER);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Formato de data inválido. Use dd/MM/yyyy HH:mm.");
        }
    }

    private final AvailabilityDao availabilityDao = new AvailabilityDao();

    private void fetchAvailableSlotsOfMentor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String teacherIdParam = request.getParameter("teacherId");
        try {
            int teacherId = Integer.parseInt(teacherIdParam);

            List<Availability> slots = availabilityDao.findActiveByUser(teacherId);

            // Convert to simple map for JSON serialization
            List<Map<String, String>> result = new ArrayList<>();
            for (Availability slot : slots) {
                Map<String, String> map = new java.util.LinkedHashMap<>();
                map.put("day", slot.getDayWeek().name());
                map.put("dayLabel", translateDayToLabel(slot.getDayWeek()));
                map.put("start", slot.getHourStart().toString());
                map.put("end", slot.getHourEnd().toString());
                result.add(map);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            response.setStatus(400);
        }
    }

    private String translateDayToLabel(java.time.DayOfWeek day) {
        switch (day) {
            case MONDAY: return "Segunda-feira";
            case TUESDAY: return "Terça-feira";
            case WEDNESDAY: return "Quarta-feira";
            case THURSDAY: return "Quinta-feira";
            case FRIDAY: return "Sexta-feira";
            case SATURDAY: return "Sábado";
            case SUNDAY: return "Domingo";
            default: return day.name();
        }
    }
}