package com.aura.user.controllers;

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
            default -> listAll(request, response);
        }
    }

    private void listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
}