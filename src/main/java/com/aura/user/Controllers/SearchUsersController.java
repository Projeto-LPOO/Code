package com.aura.user.Controllers;

import com.aura.user.Dao.UserDao;
import com.aura.user.Models.CommercialUser;
import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.lang.reflect.Type;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/autenticado/searchUsers")
public class SearchUsersController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new JsonSerializer<LocalDate>() {
                @Override
                public JsonElement serialize(LocalDate date, Type type, JsonSerializationContext context) {
                    return new JsonPrimitive(date.toString());
                }
            })
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String name = request.getParameter("name");
        if(name == null)
        {
            name = "";
        }

        List<CommercialUser> commercialUsers = userDao.findByName(name);


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String json = gson.toJson(commercialUsers);
        response.getWriter().write(json);

    }
}
