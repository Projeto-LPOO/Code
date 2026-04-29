package com.aura.user.controllers;

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

public class UsersController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    private static final String VIEW_BASE = "/WEB-INF/views/autenticado/";

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

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isBlank()) {
            return "/";
        }

        String cleanPath = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        String[] parts = cleanPath.split("/");

        return parts.length > 1 ? parts[1].toLowerCase() : "/";
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {

        req.getRequestDispatcher(VIEW_BASE + view)
                .forward(req, resp);
    }
}