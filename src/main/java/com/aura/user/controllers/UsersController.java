package com.aura.user.controllers;

import com.aura.shared.controllers.BaseController;
import com.aura.shared.security.BCryptPasswordHasher;
import com.aura.shared.security.PasswordHasher;
import com.aura.user.dao.UserDao;
import com.aura.user.models.CommercialUser;
import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = getAction(req);

        switch (action) {
            case "search" -> search(req, resp);
            default -> listAll(req, resp);
        }
    }

    private void listAll(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<CommercialUser> users = userDao.findAll();

        req.setAttribute("commercialUsers", users);

        forward(req, resp, "userList.jsp");
    }

    private void search(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String name = req.getParameter("name");
        if (name == null) name = "";

        List<CommercialUser> users = userDao.findByName(name);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        resp.getWriter().write(gson.toJson(users));
    }
}