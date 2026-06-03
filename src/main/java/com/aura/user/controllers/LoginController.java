package com.aura.user.controllers;

import com.aura.financial.dao.FinancialDao;
import com.aura.financial.models.Credits;
import com.aura.shared.security.BCryptPasswordHasher;
import com.aura.shared.security.PasswordHasher;
import com.aura.user.dao.UserDao;
import com.aura.user.models.Admin;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    private final FinancialDao financialDao = new FinancialDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        String password = request.getParameter("password");

        User user = userDao.findByEmail(email);

        PasswordHasher hasher = new BCryptPasswordHasher();


        if (user == null || !hasher.verify(password, user.getHashPassword())) {

            request.setAttribute("erro", "Email ou senha inválidos");

            request.getRequestDispatcher("WEB-INF/login.jsp").forward(request, response);

            return;
        }

        HttpSession session = request.getSession();

        session.setAttribute("user", user);

        if (user instanceof CommercialUser) {

            Credits creditsUser = financialDao.findById(user.getId());

            if (creditsUser != null) {
                session.setAttribute("isCommercial", user instanceof CommercialUser);
                session.setAttribute("creditsBalance", creditsUser.getBalance());
            }
            response.sendRedirect(request.getContextPath() + "/autenticado/home");

            return;
        }

        if (user instanceof Admin) {
            response.sendRedirect(request.getContextPath() + "/autenticado/admin");

            return;
        }
        response.sendRedirect(request.getContextPath() + "/");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("WEB-INF/login.jsp")
                .forward(request, response);
    }
}