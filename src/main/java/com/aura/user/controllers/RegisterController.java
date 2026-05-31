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
import java.sql.SQLException;

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
            cpf = cpf.replaceAll("\\D", "");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Nome é obrigatório.");
            }

            if (email == null || email.trim().isEmpty() || !email.contains("@")) {
                throw new IllegalArgumentException("Email inválido.");
            }
            if (userDao.emailExists(email))
                throw new IllegalArgumentException("E-mail já cadastrado.");

            if (password == null || password.length() < 6) {
                throw new IllegalArgumentException("Senha deve ter pelo menos 6 caracteres.");
            }

            if (age < 16 || age > 100) {
                throw new IllegalArgumentException("Idade inválida.");
            }

            if (cpf == null || cpf.trim().isEmpty()) {
                throw new IllegalArgumentException("CPF é obrigatório.");
            }

            if (!isValid(cpf)) {
                throw new IllegalArgumentException("CPF inválido.");
            }
            if(userDao.cpfExists(cpf)) {
                request.setAttribute("error", "CPF já cadastrado.");
                request.getRequestDispatcher("/WEB-INF/views/register/register.jsp")
                        .forward(request, response);
                return;
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
            request.setAttribute("name", request.getParameter("name"));
            request.setAttribute("age", request.getParameter("age"));
            request.setAttribute("address", request.getParameter("address"));
            request.setAttribute("phone", request.getParameter("phone"));
            request.setAttribute("cpf", request.getParameter("cpf"));
            request.setAttribute("email", request.getParameter("email"));

            forward(request, response, "/register/register.jsp");

        } catch (Exception e) {

            String message = e.getMessage() == null ? "" : e.getMessage().toLowerCase();

            if (message.contains("unique") || message.contains("duplicate") || message.contains("cpf")) {
                request.setAttribute("error", "CPF já cadastrado.");
                request.setAttribute("name", request.getParameter("name"));
                request.setAttribute("age", request.getParameter("age"));
                request.setAttribute("address", request.getParameter("address"));
                request.setAttribute("phone", request.getParameter("phone"));
                request.setAttribute("cpf", request.getParameter("cpf"));
                request.setAttribute("email", request.getParameter("email"));
                forward(request, response, "/register/register.jsp");
                return;
            }

            throw new ServletException(e);
        }


    }
    public static boolean isValid(String cpf) {

        if (cpf == null) return false;

        cpf = cpf.replaceAll("\\D", "");

        if (cpf.length() != 11) return false;

        if (cpf.matches("(\\d)\\1{10}")) return false;

        int[] nums = new int[11];

        for (int i = 0; i < 11; i++) {
            nums[i] = cpf.charAt(i) - '0';
        }

        int soma = 0;
        for (int i = 0, peso = 10; i < 9; i++, peso--) {
            soma += nums[i] * peso;
        }

        int dv1 = 11 - (soma % 11);
        if (dv1 >= 10) dv1 = 0;

        soma = 0;
        for (int i = 0, peso = 11; i < 10; i++, peso--) {
            soma += nums[i] * peso;
        }

        int dv2 = 11 - (soma % 11);
        if (dv2 >= 10) dv2 = 0;

        return nums[9] == dv1 && nums[10] == dv2;

    }
}