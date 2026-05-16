package com.aura.shared.controllers;

import com.aura.availability.controllers.AvailabilityController;
import com.aura.financial.controllers.FinancialController;
import com.aura.interest.controllers.InterestController;
import com.aura.meeting.controller.MeetingController;
import com.aura.meeting.controller.MeetingWebController;
import com.aura.user.controllers.UsersController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/autenticado/*")
public class FrontController extends HttpServlet {

    private final Map<String, HttpServlet> routes = new HashMap<>();

    @Override
    public void init() throws ServletException {

        // adiciona os controller com suas chaves que é a url
        routes.put("/home", new HomeController());
        routes.put("/users", new UsersController());
        routes.put("/interest", new InterestController());
        routes.put("/availability", new AvailabilityController());
        routes.put("/financial", new FinancialController());
        routes.put("/meeting", new MeetingWebController());

        for (HttpServlet controller : routes.values()) {
            controller.init(getServletConfig()); //inicia manualmente cada controller
        }
    }
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = extractPath(request);


        if (path.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/autenticado/home");
            return;
        }

        HttpServlet controller = routes.get(path);

        if (controller == null) {
            response.sendError(404);
            return;
        }

        controller.service(request, response);
    }
    private String extractPath(HttpServletRequest req) {
        String pathInfo = req.getPathInfo(); // ex: /interest/learn

        if (pathInfo == null || pathInfo.equals("/")) {
            return "/";
        }

        String[] parts = pathInfo.split("/");

        return parts.length > 1 ? "/" + parts[1] : "/";
    }
}
