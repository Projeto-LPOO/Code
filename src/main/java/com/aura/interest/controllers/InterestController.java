package com.aura.interest.controllers;

import com.aura.category.Category;
import com.aura.category.CategoryDao;
import com.aura.interest.dao.InterestDao;
import com.aura.interest.model.Interest;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

public class InterestController extends HttpServlet {

    private final InterestDao interestDao = new InterestDao();
    private final CategoryDao categoryDAO = new CategoryDao();
    private static final String VIEW_BASE = "/WEB-INF/views/autenticado/";


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {
            default -> listAll(request, response);
        }
    }
    private void  listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        List<Interest> interestList = interestDao.findAll();
        request.setAttribute("interestList", interestList);
        forward(request, response, "interestList.jsp");
    }
    private String getAction(HttpServletRequest req)
    {
        String pathInfo = req.getPathInfo();

        if(pathInfo == null || pathInfo.isBlank() || pathInfo.equals("/"))
        {
            return "/"; //definir padrão
        }
        String cleanPath = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        String parts[] = cleanPath.split("/");

        return parts.length > 1 ? parts[1].toLowerCase() : "/";
    }
    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {

        req.getRequestDispatcher(VIEW_BASE + view)
                .forward(req, resp);
    }
}