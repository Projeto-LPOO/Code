package com.aura.user.controllers;

import com.aura.meeting.dao.ReportDao;
import com.aura.meeting.model.MeetingReport;
import com.aura.meeting.model.ReportingMetrics;
import com.aura.shared.controllers.BaseController;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class AdminController extends BaseController {

    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action =
                getAction(request);

        switch (action) {

            case "/" ->
                    showReports(
                            request,
                            response
                    );

            default ->
                    response.sendError(404);
        }
    }

    private void showReports(
            HttpServletRequest request,
            HttpServletResponse response
    )
            throws ServletException, IOException {

        List<MeetingReport> meetingReportList = reportDao.findAllReports();

        ReportingMetrics stats = reportDao.getReportingMetrics();

        request.setAttribute("meetingReportList", meetingReportList);

        request.setAttribute("reportStats", stats);

        forward(request, response, "/autenticado/dashboardAdmin.jsp");
    }
}