package com.aura.meeting.controller;

import com.aura.feedback.dao.FeedbackDao;
import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.model.Meeting;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/autenticado/meeting")
public class MeetingListController extends BaseController {

    private final MeetingController meetingController = new MeetingController();
    private final FeedbackDao feedbackDao = new FeedbackDao();
    private final MeetingDao reportDao = new MeetingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Meeting> meetings = meetingController.findByUserIdWithRole(loggedUser.getId());

        Map<Integer, String> typeMap = new HashMap<>();
        Map<Integer, Boolean> feedbackDoneMap = new HashMap<>();
        Map<Integer, Boolean> reportDoneMap = new HashMap<>();

        for (Meeting m : meetings) {
            boolean isDone     = "done".equalsIgnoreCase(m.getStatus());
            boolean isReported = "reported".equalsIgnoreCase(m.getStatus());

            typeMap.put(m.getId(), m.getMeetingType());
            feedbackDoneMap.put(m.getId(),
                    "done".equalsIgnoreCase(m.getStatus())
                            && feedbackDao.hasFeedbackFromUser(m.getId(), loggedUser.getId())
            );

            reportDoneMap.put(m.getId(),
                    (isDone || isReported) && reportDao.hasReportFromUser(m.getId(), loggedUser.getId())
            );
        }

        // move mensagens de sessão para o request (exibe uma única vez)
        for (String key : new String[]{"successMsg", "erroMsg", "statusError"}) {
            Object val = session != null ? session.getAttribute(key) : null;
            if (val != null) {
                request.setAttribute(key, val);
                session.removeAttribute(key);
            }
        }

        request.setAttribute("meetings", meetings);
        request.setAttribute("typeMap", typeMap);
        request.setAttribute("feedbackDoneMap", feedbackDoneMap);
        request.setAttribute("reportDoneMap", reportDoneMap);

        forward(request, response, "autenticado/meetingList.jsp");
    }
}