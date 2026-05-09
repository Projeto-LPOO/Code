package com.aura.meeting.controller;

import com.aura.shared.controllers.BaseController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class MeetingWebController extends BaseController {

    private final MeetingListController   listController   = new MeetingListController();
    private final MeetingCreateController createController = new MeetingCreateController();
    private final MeetingDeleteController deleteController = new MeetingDeleteController();
    private final MeetingUpdateController updateController = new MeetingUpdateController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = getAction(req);
        switch (action) {
            case "register" -> createController.doGet(req, res);
            default         -> listController.doGet(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = getAction(req);
        switch (action) {
            case "register" -> createController.doPost(req, res);
            case "delete"   -> deleteController.doPost(req, res);
            case "update"   -> updateController.doPost(req, res);
            default         -> res.sendError(404);
        }
    }
}
