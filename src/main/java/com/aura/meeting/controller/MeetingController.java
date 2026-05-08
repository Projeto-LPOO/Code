package com.aura.meeting.controller;

import com.aura.meeting.dao.MeetingDao;
import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;

import java.time.LocalDateTime;
import java.util.List;

public class MeetingController {

    private final MeetingDao meetingDao = new MeetingDao();

    public void register(Meeting meeting) {
        if (meeting.getDescription() == null || meeting.getDescription().trim().isEmpty())
            throw new IllegalArgumentException("Descrição do meeting é obrigatória.");
        if (meeting.getDayTime() == null)
            throw new IllegalArgumentException("Data e hora do meeting são obrigatórias.");
        if (meeting.getDayTime().isBefore(LocalDateTime.now()))
            throw new IllegalArgumentException("A data do meeting não pode ser no passado.");
        if (meeting.getLearner() == null)
            throw new IllegalArgumentException("O meeting precisa de um aluno.");
        if (meeting.getTeacher() == null)
            throw new IllegalArgumentException("O meeting precisa de um professor.");


        if (meetingDao.hasConflict(meeting.getTeacher().getId(), meeting.getDayTime()))
            throw new IllegalArgumentException("O professor já possui um meeting agendado neste horário.");


        if (meeting instanceof FaceToFaceMeeting ftf) {
            if (ftf.getLocation() == null)
                throw new IllegalArgumentException("Meeting presencial precisa de uma localização.");
            Location loc = ftf.getLocation();
            if (loc.getCity() == null || loc.getCity().trim().isEmpty())
                throw new IllegalArgumentException("Cidade da localização é obrigatória.");
            if (loc.getStreet() == null || loc.getStreet().trim().isEmpty())
                throw new IllegalArgumentException("Rua da localização é obrigatória.");
        }

        meetingDao.register(meeting);
    }

    public Meeting findById(int meetingId) {
        if (meetingId <= 0)
            throw new IllegalArgumentException("ID inválido.");
        return meetingDao.findById(meetingId);
    }

    public List<Meeting> findAll() {
        return meetingDao.findAll();
    }

    public List<Meeting> findByUserId(int userId) {
        if (userId <= 0)
            throw new IllegalArgumentException("ID de usuário inválido.");
        return meetingDao.findByUserId(userId);
    }

    }

    public List<Meeting> findByUserId(int userId) {
        if (userId <= 0)
            throw new IllegalArgumentException("ID de usuário inválido.");
        return meetingDao.findByUserId(userId);
    }

    public void update(Meeting meeting) {
        if (meeting.getId() <= 0)
            throw new IllegalArgumentException("ID do meeting inválido para atualização.");
        if (meeting.getDescription() == null || meeting.getDescription().trim().isEmpty())
            throw new IllegalArgumentException("Descrição do meeting é obrigatória.");
        if (meeting.getDayTime() == null)
            throw new IllegalArgumentException("Data e hora do meeting são obrigatórias.");
        if (meeting.getStatus() == null || meeting.getStatus().trim().isEmpty())
            throw new IllegalArgumentException("Status do meeting é obrigatório.");

        meetingDao.update(meeting);
    }

    public void delete(int meetingId) {
        if (meetingId <= 0)
            throw new IllegalArgumentException("ID inválido para exclusão.");
        meetingDao.delete(meetingId);
    }
}