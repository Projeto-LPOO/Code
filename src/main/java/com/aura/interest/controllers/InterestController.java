package com.aura.interest.controllers;

import com.aura.category.Category;
import com.aura.category.CategoryDao;
import com.aura.interest.dao.InterestDao;
import com.aura.interest.dao.UserInterestDao;
import com.aura.interest.model.Interest;

import com.aura.interest.model.InterestType;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

public class InterestController extends BaseController {

    private final InterestDao interestDao = new InterestDao();
    private final CategoryDao categoryDAO = new CategoryDao();
    private final UserInterestDao userInterestDao = new UserInterestDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        loadInterests(request);

        switch (action) {
            case "skills" -> forward(request, response, "/autenticado/skillList.jsp");
            case "learn" -> forward(request, response, "/autenticado/learnList.jsp");
            default -> forward(request, response, "/autenticado/learnList.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);


        switch (action) {
            case "learn" -> registerUserLearn(request, response);
            case "skills" -> registerUserSkills(request, response);
            default -> response.sendError(404);
        }
    }

    private void loadInterests(HttpServletRequest request)
    {
        List<Category> categories = categoryDAO.findAll();
        List<Interest> interests = interestDao.findAll();

        Map<Integer, List<Interest>> interestsByCategory = new HashMap<>();

        for (Interest interest : interests) {
            int categoryId = interest.getCategory().getId();

            interestsByCategory
                    .computeIfAbsent(categoryId, k -> new ArrayList<>())
                    .add(interest);
        }

        request.setAttribute("categories", categories);
        request.setAttribute("interestsByCategory", interestsByCategory);
    }
    private void registerUserLearn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String [] interestsLearn = request.getParameterValues("interests");
        List<Integer> ids = new ArrayList<>();

        if (interestsLearn != null) {
            for (String inter : interestsLearn) {
                try {
                    ids.add(Integer.parseInt(inter));
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        userInterestDao.registerUserLearn(user.getId(), ids, InterestType.Learn);
        response.sendRedirect(request.getContextPath() + "/autenticado/interest/skills");
    }
    private void registerUserSkills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String [] interestsSkills = request.getParameterValues("interests");
        List<Integer> ids = new ArrayList<>();

        if (interestsSkills != null) {
            for (String inter : interestsSkills) {
                try {
                    ids.add(Integer.parseInt(inter));
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        userInterestDao.registerUserLearn(user.getId(), ids, InterestType.Skill);
        response.sendRedirect(request.getContextPath() + "/autenticado/home");
    }

}