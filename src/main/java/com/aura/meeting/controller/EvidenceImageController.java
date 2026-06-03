package com.aura.meeting.controller;

import com.aura.shared.controllers.BaseController;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;

@WebServlet("/evidenceuploads")
public class EvidenceImageController extends BaseController  {

    private static final String BASE_DIR = "/data/evidenceuploads";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String fileName = req.getParameter("file");

        if (fileName == null || fileName.isBlank()) {
            resp.sendError(400);
            return;
        }

        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            resp.sendError(403);
            return;
        }

        File file = new File(BASE_DIR, fileName);

        if (!file.exists()) {
            resp.sendError(404);
            return;
        }

        resp.setContentType(getServletContext().getMimeType(file.getName()));

        try (var in = new java.io.FileInputStream(file);
             var out = resp.getOutputStream()) {

            in.transferTo(out);
        }
    }
}
