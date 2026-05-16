package com.aura.user.controllers;

import com.aura.financial.dao.FinancialDao;
import com.aura.financial.models.Credits;
import com.aura.shared.security.BCryptPasswordHasher;
import com.aura.shared.security.PasswordHasher;
import com.aura.user.dao.UserDao;
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
public class LoginController extends HttpServlet{

    private final UserDao userDao = new UserDao();
    private final FinancialDao financialDao = new FinancialDao();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDao.findByEmail(email);
        if(user == null)
        {
            request.getRequestDispatcher("WEB-INF/login.jsp").forward(request, response);

        }
        Credits creditsUser = financialDao.findById(user.getId());


        PasswordHasher hasher = new BCryptPasswordHasher();

        if(user != null && hasher.verify(password,user.getHashPassword()))
        {
            HttpSession session = request.getSession();
            session.setAttribute("user",user);
            session.setAttribute("creditsBalance", creditsUser.getBalance());
            response.sendRedirect(request.getContextPath() + "/autenticado/home");
        }
        else{
            request.setAttribute("erro", "Email ou senha inválidos");
            request.getRequestDispatcher("WEB-INF/login.jsp").forward(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("WEB-INF/login.jsp").forward(request, response);
    }
}
