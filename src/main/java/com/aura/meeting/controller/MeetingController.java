package com.aura.meeting.controller;

import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.OnlineMeeting;

import java.time.LocalDateTime;
import java.util.List;

public class MeetingController {

    private MeetingDao meetingDao = new MeetingDao();

    public void registerMeeting(Meeting meeting) {
        if (meeting.getDescription() == null || meeting.getDescription().trim().isEmpty()) {
            throw new IllegalArgumentException("Descrição do meeting é obrigatória.");
        }
        if (meeting.getDayTime() == null) {
            throw new IllegalArgumentException("Data e hora do meeting são obrigatórias.");
        }
        if (meeting.getDayTime().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("A data do meeting não pode ser no passado.");
        }
//        if (meeting.getLearner() == null) {
//            throw new IllegalArgumentException("O meeting precisa de um Learner.");
//        }
//        if (meeting.getTeacher() == null) {
//            throw new IllegalArgumentException("O meeting precisa de um Teacher.");
//        }
        if (meeting instanceof FaceToFaceMeeting ftf) {
            if (ftf.getLocation() == null) {
                throw new IllegalArgumentException("Meeting presencial precisa de uma localização.");
            }
            Location loc = ftf.getLocation();
            if (loc.getCity() == null || loc.getCity().trim().isEmpty()) {
                throw new IllegalArgumentException("Cidade da localização é obrigatória.");
            }
            if (loc.getStreet() == null || loc.getStreet().trim().isEmpty()) {
                throw new IllegalArgumentException("Rua da localização é obrigatória.");
            }
        }

        meetingDao.registerMeeting(meeting);
    }

//    public List<String> getMeetings() {
//        return meetingDao.getMeetings();
//    }

    public Meeting getById(int meetingId) {
        if (meetingId <= 0) {
            throw new IllegalArgumentException("ID inválido.");
        }
        return meetingDao.getById(meetingId);
    }

    public void updateMeeting(Meeting meeting) {
        if (meeting.getId() <= 0) {
            throw new IllegalArgumentException("ID do meeting inválido para atualização.");
        }
        if (meeting.getDescription() == null || meeting.getDescription().trim().isEmpty()) {
            throw new IllegalArgumentException("Descrição do meeting é obrigatória.");
        }
        if (meeting.getDayTime() == null) {
            throw new IllegalArgumentException("Data e hora do meeting são obrigatórias.");
        }
        if (meeting.getStatus() == null || meeting.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Status do meeting é obrigatório.");
        }

        meetingDao.updateMeeting(meeting);
    }

    public void deleteMeeting(int meetingId) {
        if (meetingId <= 0) {
            throw new IllegalArgumentException("ID inválido para exclusão.");
        }
        meetingDao.deleteMeeting(meetingId);
    }
}
