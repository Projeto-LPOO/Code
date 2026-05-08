package com.aura.shared.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class BaseController extends HttpServlet {

    protected static final String VIEW_BASE = "/WEB-INF/views/";

    protected String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isBlank()) {
            return "/";
        }

        String[] parts = pathInfo.split("/");

        return parts.length > 2 ? parts[2].toLowerCase() : "/";
    }

    protected void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {

        req.getRequestDispatcher(VIEW_BASE + view)
                .forward(req, resp);
    }
}
