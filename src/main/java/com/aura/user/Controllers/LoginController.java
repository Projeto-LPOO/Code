package com.aura.user.Controllers;

import com.aura.shared.security.BCryptPasswordHasher;
import com.aura.shared.security.PasswordHasher;
import com.aura.user.Dao.UserDao;
import com.aura.user.Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDao.findByEmail(email);
        PasswordHasher hasher = new BCryptPasswordHasher();

        if(user != null && hasher.verify(password,user.getHashPassword()))
        {
            HttpSession session = request.getSession();
            session.setAttribute("user",user);
            response.sendRedirect(request.getContextPath() + "/autenticado/home.jsp");
        }
        else{
            request.setAttribute("erro", "Email ou senha inválidos");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
