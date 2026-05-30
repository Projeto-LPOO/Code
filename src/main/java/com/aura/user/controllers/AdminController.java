package com.aura.user.controllers;

import com.aura.meeting.controller.ReportController;
import com.aura.meeting.dao.ReportDao;
import com.aura.meeting.model.EvidenceAccepted;
import com.aura.meeting.model.MeetingReport;
import com.aura.meeting.model.ReportEvidence;
import com.aura.meeting.model.ReportingMetrics;
import com.aura.shared.controllers.BaseController;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class AdminController extends BaseController {

    private final ReportDao reportDao = new ReportDao();
    private final ReportController reportController = new ReportController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {

            case "/" -> showReports(request, response);
            case "evidences" -> showEvidences(request, response);
            default -> response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);

        switch (action)
        {
                case "approve" -> acceptedEvidence(request, response);
                case "reject" -> rejectEvidence(request, response);
        }
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<MeetingReport> meetingReportList = reportDao.findAllReports();

        ReportingMetrics stats = reportDao.getReportingMetrics();

        request.setAttribute("meetingReportList", meetingReportList);

        request.setAttribute("reportStats", stats);

        forward(request, response, "/autenticado/dashboardAdmin.jsp");
    }
    private void showEvidences(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException
    {
        request.setAttribute("evidencesPendentes", reportController.getPendentes());
        request.setAttribute("evidencesApproved", reportController.getApproved());
        request.setAttribute("evidencesRecused", reportController.getRecused());

        forward(request, response, "/autenticado/evidenceViewAdmin.jsp");
    }

    private void acceptedEvidence(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException
    {
        int evidenceId = Integer.parseInt(request.getParameter("evidenceId"));
        int meetingId = Integer.parseInt(request.getParameter("meetingId"));
        reportDao.updateEvidenceAccept(evidenceId, EvidenceAccepted.ACEITO);
        reportDao.updateReportStatus(meetingId);
        response.sendRedirect(request.getContextPath() + "/autenticado/admin/evidences");

    }
    private void rejectEvidence(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException
    {
        int evidenceId = Integer.parseInt(request.getParameter("evidenceId"));
        reportDao.updateEvidenceAccept(evidenceId, EvidenceAccepted.RECUSADO);
        int meetingId = Integer.parseInt(request.getParameter("meetingId"));
        reportDao.updateReportStatus(meetingId);

        response.sendRedirect(request.getContextPath() +"/autenticado/admin/evidences");

    }
}