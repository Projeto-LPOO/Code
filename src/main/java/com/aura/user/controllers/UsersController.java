package com.aura.user.controllers;

import com.aura.availability.dao.AvailabilityDao;
import com.aura.availability.models.Availability;
import com.aura.shared.controllers.BaseController;
import com.aura.user.dao.UserDao;
import com.aura.user.models.CommercialUser;
import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public class UsersController extends BaseController {

    private final UserDao userDao = new UserDao();
    private final AvailabilityDao availabilityDao = new AvailabilityDao();

    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class,
                    (JsonSerializer<LocalDate>) (date, type, context) ->
                            new JsonPrimitive(date.toString()))
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {
            case "search" -> search(request, response);
            case "profile" -> showProfile(request, response);
            default -> listAll(request, response);
        }
    }

    private void listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // by little daniel
        List<CommercialUser> users = userDao.findAll();

        request.setAttribute("commercialUsers", users);

        forward(request, response, "autenticado/userList.jsp");
    }

    private void search(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");
        if (name == null) name = "";

        List<CommercialUser> users = userDao.findByName(name);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write(gson.toJson(users));
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                CommercialUser user = userDao.findById(id);

                if (user != null) {
                    List<Availability> schedules = availabilityDao.findAllAvailability(id);

                    if (schedules != null) {
                        schedules.sort((a, b) -> {
                            int dayComp = a.getDayWeek().compareTo(b.getDayWeek());
                            return (dayComp == 0)
                                    ? a.getHourStart().compareTo(b.getHourStart())
                                    : dayComp;
                        });
                    }

                    request.setAttribute("user", user);
                    request.setAttribute("schedules", schedules);

                    forward(request, response, "autenticado/userProfile.jsp");
                    return;
                }
            } catch (NumberFormatException e) {}
        }
        response.sendRedirect(request.getContextPath() + "/users");
    }
}