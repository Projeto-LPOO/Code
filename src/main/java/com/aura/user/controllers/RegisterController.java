package com.aura.user.controllers;

import com.aura.shared.controllers.BaseController;
import com.aura.shared.security.BCryptPasswordHasher;
import com.aura.shared.security.PasswordHasher;
import com.aura.user.dao.UserDao;
import com.aura.user.models.CommercialUser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends BaseController {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        forward(request, response, "/register/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String name = request.getParameter("name");
            int age = Integer.parseInt(request.getParameter("age"));
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String cpf = request.getParameter("cpf");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Nome é obrigatório.");
            }

            if (email == null || email.trim().isEmpty() || !email.contains("@")) {
                throw new IllegalArgumentException("Email inválido.");
            }

            if (password == null || password.length() < 6) {
                throw new IllegalArgumentException("Senha deve ter pelo menos 6 caracteres.");
            }

            if (age < 16 || age > 100) {
                throw new IllegalArgumentException("Idade inválida.");
            }

            if (cpf == null || cpf.trim().isEmpty()) {
                throw new IllegalArgumentException("CPF é obrigatório.");
            }

            if (cpf.length() != 11 && cpf.length() != 14) {
                throw new IllegalArgumentException("CPF inválido.");
            }

            if (phone != null && !phone.trim().isEmpty() && phone.length() < 8) {
                throw new IllegalArgumentException("Telefone inválido.");
            }

            if (address == null || address.trim().isEmpty()) {
                throw new IllegalArgumentException("Endereço é obrigatório.");
            }

            PasswordHasher hasher = new BCryptPasswordHasher();
            String hashPassword = hasher.hash(password);


            CommercialUser user = new CommercialUser(name, age, address, phone, cpf, email, hashPassword);

           CommercialUser commercialUser = userDao.registerUser(user);

            HttpSession session = request.getSession();
            session.setAttribute("user", commercialUser);

            response.sendRedirect(request.getContextPath() + "/autenticado/interest/learn");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            forward(request, response, "users/register.jsp");

        }
    }

}