package com.aura.user.Controllers;

import com.aura.user.Dao.UserDao;
import com.aura.user.Models.CommercialUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/autenticado/users")
public class UsersListController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CommercialUser> commercialUsers = userDao.findAll();

        request.setAttribute("commercialUsers", commercialUsers);
        request.getRequestDispatcher("/autenticado/UserList.jsp").forward(request, response);
    }
}
