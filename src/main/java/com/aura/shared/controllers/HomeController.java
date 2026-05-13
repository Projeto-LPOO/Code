package com.aura.shared.controllers;

import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.model.Meeting;
import com.aura.user.dao.UserDao;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class HomeController extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final MeetingDao meetingDao = new MeetingDao();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        CommercialUser commercialUser = (CommercialUser) user;
        Meeting upCommingMetting = meetingDao.findNextMeetingByUserId(commercialUser.getId());
        List<CommercialUser> mentors = userDao.holdMentor(commercialUser);

        req.setAttribute("upCommingMetting", upCommingMetting);
        req.setAttribute("mentors", mentors);
        req.getRequestDispatcher("/WEB-INF/views/autenticado/home.jsp")
                .forward(req, resp);
    }
}
