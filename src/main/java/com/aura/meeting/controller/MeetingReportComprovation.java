package com.aura.meeting.controller;

import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.dao.ReportDao;
import com.aura.meeting.model.MeetingReport;
import com.aura.meeting.model.ReportEvidence;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@MultipartConfig
@WebServlet("/autenticado/meeting/comprovation")
public class MeetingReportComprovation extends BaseController {

    private final MeetingDao meetingDao = new MeetingDao();
    private final ReportDao reportDao = new ReportDao();

    private static final String UPLOAD_DIR = "/data/evidenceuploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int reportId = Integer.parseInt(request.getParameter("id"));
        MeetingReport report = reportDao.findReportById(reportId);

        request.setAttribute("report", report);
        forward(request, response, "autenticado/comprovationReport.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CommercialUser cmmu = (CommercialUser) loggedUser;

        int reportId = Integer.parseInt(request.getParameter("reportId"));
        String evidenceDescription = request.getParameter("evidenceDescription");
        Part imagePart = request.getPart("evidenceImage");

        MeetingReport meetingReport = reportDao.findReportById(reportId);

        String originalFileName = imagePart.getSubmittedFileName();
        String fileName = System.currentTimeMillis() + "_" + originalFileName;

        File uploadDir = new File(UPLOAD_DIR);

        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        File file = new File(uploadDir, fileName);
        imagePart.write(file.getAbsolutePath());

        ReportEvidence evidence = new ReportEvidence();
        evidence.setReport(meetingReport);
        evidence.setUser(cmmu);
        evidence.setDescription(evidenceDescription);

        evidence.setImagePath(fileName);

        reportDao.registerEvidence(evidence);

        response.sendRedirect(request.getContextPath() + "/autenticado/meeting");
    }
}