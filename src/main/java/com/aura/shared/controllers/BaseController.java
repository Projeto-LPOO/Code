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

        String cleanPath = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        String[] parts = cleanPath.split("/");

        return parts.length > 1 ? parts[1].toLowerCase() : "/";
    }

    protected void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {

        req.getRequestDispatcher(VIEW_BASE + view)
                .forward(req, resp);
    }
}
