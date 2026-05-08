package com.aura.meeting.controller;

import com.aura.category.Category;
import com.aura.interest.dao.InterestDao;
import com.aura.interest.model.Interest;
import com.aura.meeting.dao.MeetingDao;
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

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class MeetingController extends BaseController {

    private final MeetingDao meetingDao = new MeetingDao(); // seu DAO existente
    private final InterestDao interestDao = new InterestDao();
    private final UserDao userDao = new UserDao();
    private final Gson gson = new Gson();

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {
            case "register"          -> showRegisterForm(request, response);
            case "mentorcategories"  -> fetchCategoriesOfMentor(request, response);
            case "mentorinterests"   -> fetchInterestsOfMentorByCategory(request, response);
            default                  -> listAll(request, response);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {
            case "register" -> register(request, response);
            case "update"   -> update(request, response);
            case "delete"   -> delete(request, response);
            default         -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    private void listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Meeting> meetings = meetingDao.findByUserId(loggedUser.getId());

        Map<Integer, String> typeMap = new LinkedHashMap<>();
        for (Meeting m : meetings) {
            typeMap.put(m.getId(), m instanceof FaceToFaceMeeting ? "PRESENCIAL" : "ONLINE");
        }

        request.setAttribute("meetings", meetings);
        request.setAttribute("tipoMap", typeMap);
        forward(request, response, "autenticado/meetingList.jsp");
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
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

    private void register(HttpServletRequest request, HttpServletResponse response)
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

            meetingDao.register(meeting);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("tipo", meetingType);
            request.setAttribute("descricao", description);
            request.setAttribute("dataHora", dateStr);
            request.setAttribute("preselectedTeacherId", teacherIdParam);
            showRegisterForm(request, response);
        }
    }

    private void update(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam   = request.getParameter("id");
        String descricao = request.getParameter("descricao");
        String dataStr   = request.getParameter("dataHora");
        String status    = request.getParameter("status");

        try {
            if (idParam == null || idParam.trim().isEmpty())
                throw new IllegalArgumentException("ID do meeting é obrigatório.");

            int id = Integer.parseInt(idParam);
            Meeting meeting = meetingDao.findById(id);

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
                String cidade  = request.getParameter("cidade");
                String rua     = request.getParameter("rua");
                String numStr  = request.getParameter("numero");

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

            meetingDao.register(meeting);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("id");

        try {
            if (idParam == null || idParam.trim().isEmpty())
                throw new IllegalArgumentException("ID do meeting é obrigatório.");

            int id = Integer.parseInt(idParam);

            if (meetingDao.findById(id) == null)
                throw new IllegalArgumentException("Meeting não encontrado.");

            meetingDao.delete(id);
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
        }
    }

    private void fetchCategoriesOfMentor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int teacherId = Integer.parseInt(request.getParameter("teacherId"));
            CommercialUser mentor = userDao.findByIdWithInterests(teacherId);
            if (mentor == null) { response.setStatus(404); return; }

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

        try {
            int teacherId  = Integer.parseInt(request.getParameter("teacherId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            CommercialUser mentor = userDao.findByIdWithInterests(teacherId);
            if (mentor == null) { response.setStatus(404); return; }

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

    // ------------------------------------------------------------ HELPERS ---

    private LocalDateTime parseDateTime(String str) {
        try {
            return LocalDateTime.parse(str, FORMATTER);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Formato de data inválido. Use dd/MM/yyyy HH:mm.");
        }
    }
}