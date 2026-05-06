package com.aura.meeting.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.OnlineMeeting;
import com.aura.user.models.Learner;
import com.aura.user.models.Teacher;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class MeetingDao {

    public void registerMeeting(Meeting meeting) {
        String tabelaMeeting = "INSERT INTO meetings(description, scheduled_at, meeting_type, status)" + "VALUES(?, ?, ?::meeting_type_enum, ?::meeting_status)";
        String tabelaLocation = "INSERT INTO locations(city, neighborhood, street, house_number, reference_point)" + "VALUES(?, ?, ?, ?, ?)";
        String tabelaMeetingParticipantsTeacher = "INSERT INTO meeting_participants(meeting_id, user_id, role)" + "VALUES(?, ?, 'TEACHER'::participant_role)";
        String tabelaMeetingParticipantsLearner = "INSERT INTO meeting_participants(meeting_id, user_id, role)" + "VALUES(?, ?, 'LEARNER'::participant_role)";

        try(Connection conn = dbFactory.getConnection())
        {
            try
            {
                conn.setAutoCommit(false);
                int meetingid = 0;

                try (PreparedStatement pstmt = conn.prepareStatement(tabelaMeeting, Statement.RETURN_GENERATED_KEYS))
                {
                    pstmt.setString(1, meeting.getDescription());
                    pstmt.setTimestamp(2, Timestamp.valueOf(meeting.getDayTime()));
                    if (meeting instanceof FaceToFaceMeeting)
                        pstmt.setString(3, "PRESENCIAL");
                    else
                        pstmt.setString(3, "ONLINE");
                    pstmt.setString(4, "pending");

                    pstmt.executeUpdate();

                    ResultSet rs = pstmt.getGeneratedKeys();
                    if(rs.next()) {
                        meetingid = rs.getInt(1);
                        meeting.setId(meetingid);
                    }

                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }

//                try(PreparedStatement pstmt = conn.prepareStatement(tabelaMeetingParticipantsLearner))
//                {
//                    pstmt.setInt(1, meetingid);
//                    pstmt.setInt(2, meeting.getLearner().getId());
//                    pstmt.executeUpdate();
//                }
//
//                try(PreparedStatement pstmt = conn.prepareStatement(tabelaMeetingParticipantsTeacher))
//                {
//                    pstmt.setInt(1, meetingid);
//                    pstmt.setInt(2, meeting.getTeacher().getId());
//                    pstmt.executeUpdate();
//                }

                if (meeting instanceof FaceToFaceMeeting ftf)
                {
                    try(PreparedStatement pstmt = conn.prepareStatement(tabelaLocation, Statement.RETURN_GENERATED_KEYS)) {

                        pstmt.setString(1, ftf.getLocation().getCity());
                        pstmt.setString(2, ftf.getLocation().getNeighborhood());
                        pstmt.setString(3, ftf.getLocation().getStreet());
                        pstmt.setInt(4, ftf.getLocation().getHouseNumber());
                        pstmt.setString(5, ftf.getLocation().getReferencePoint());

                        pstmt.executeUpdate();
                        ResultSet rs = pstmt.getGeneratedKeys();
                        if (rs.next()) {
                            int locationId = rs.getInt(1);
                            updateLocationId(conn, meetingid, locationId); // CORREÇÃO 3: ordem dos parâmetros corrigida
                        }
                    }
                }

                conn.commit();
                System.out.println("meeting gravado com sucesso");

            }catch (SQLException e) {
                conn.rollback();
                System.out.println("falha em algum save");
                throw new RuntimeException();
            }

        } catch (SQLException e) {
            System.out.println("falha na conexao com o banco");
            throw new RuntimeException(e);
        }
    }

    public void updateLocationId(Connection conn, int meetingId, int locationId)
    {
        String sql = "UPDATE meetings SET location_id = ? WHERE id = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, locationId);
            pstmt.setInt(2, meetingId);
            pstmt.executeUpdate(); // tinha faltado o executeUpdate() aqui também
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<String> getMeetings()
    {
        List<String> meetings = new ArrayList<>();
        String sql = "SELECT id, status, meeting_type, category_id FROM meetings";
        try(Connection conn = dbFactory.getConnection();
            PreparedStatement pstm = conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery())
        {
            int i = 0;
            while(rs.next()) {
                i++;
                String register = "MEETING[" + i + "] | " +
                        rs.getString("id") + "| " +
                        rs.getString("status") + "| " +
                        rs.getString("meeting_type") + "| " +
                        rs.getString("category_id");

                meetings.add(register);
            }

        } catch (SQLException e) {
            System.out.println("falha na conexao");
            throw new RuntimeException(e);
        }
        return meetings;
    }

    public Meeting getById(int meetingId) {

        String sql       = "SELECT * FROM meetings WHERE id = ?";
        String learnerSql = "SELECT * FROM meeting_participants WHERE meeting_id = ? AND role = 'LEARNER'";
        String teacherSql = "SELECT * FROM meeting_participants WHERE meeting_id = ? AND role = 'TEACHER'";
        String locationSql = "SELECT * FROM locations WHERE id = (SELECT location_id FROM meetings WHERE id = ?)";

        try(Connection conn = dbFactory.getConnection();
            PreparedStatement pstmt   = conn.prepareStatement(sql);
            PreparedStatement learnps = conn.prepareStatement(learnerSql);
            PreparedStatement teachps = conn.prepareStatement(teacherSql);
            PreparedStatement locps   = conn.prepareStatement(locationSql))
        {

            pstmt.setInt(1, meetingId);
            learnps.setInt(1, meetingId);
            teachps.setInt(1, meetingId);
            locps.setInt(1, meetingId);

            ResultSet rs   = pstmt.executeQuery();
            ResultSet ls   = learnps.executeQuery();
            ResultSet ts   = teachps.executeQuery();

            if (rs.next()) {
                String tipo = rs.getString("meeting_type");
                Meeting meeting;
                
             // criei um learner e teacher bem besta so pra rodar -Erick
                Learner learner = null;
                if (ls.next()) {
                    learner = new Learner();
                    learner.setId(ls.getInt("user_id"));
                }

                Teacher teacher = null;
                if (ts.next()) {
                    teacher = new Teacher();
                    teacher.setId(ts.getInt("user_id"));
                }

                if (tipo.equalsIgnoreCase("PRESENCIAL")) {
                    FaceToFaceMeeting ftf = new FaceToFaceMeeting(); // nasce como FaceToFaceMeeting
                    ftf.setId(meetingId);
                    ftf.setDescription(rs.getString("description"));
                    ftf.setStatus(rs.getString("status"));
                    ftf.setDayTime(rs.getTimestamp("scheduled_at").toLocalDateTime());
                    ftf.setLearner(learner); // criei um learner bem besta so pra rodar -Erick
                    ftf.setTeacher(teacher); // criei um learner bem besta so pra rodar -Erick
                    ftf.setCategory(null); // será preenchido futuramente

                    ResultSet locs = locps.executeQuery();
                    if (locs.next()) {
                        Location loc = new Location();
                        loc.setCity(locs.getString("city"));
                        loc.setNeighborhood(locs.getString("neighborhood"));
                        loc.setStreet(locs.getString("street"));
                        loc.setHouseNumber(locs.getInt("house_number"));
                        loc.setReferencePoint(locs.getString("reference_point"));
                        ftf.setLocation(loc);
                    }

                    meeting = ftf;

                } else {
                    OnlineMeeting om = new OnlineMeeting();
                    om.setId(meetingId);
                    om.setDescription(rs.getString("description"));
                    om.setStatus(rs.getString("status"));
                    om.setDayTime(rs.getTimestamp("scheduled_at").toLocalDateTime());
                    om.setLearner(learner);
                    om.setTeacher(teacher);
                    om.setCategory(null);

                    meeting = om;
                }

                return meeting;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    public void updateMeeting (Meeting meeting) {
        int meetingid = meeting.getId();

        String sql = """
                        UPDATE meetings
                        SET description = ?, scheduled_at = ?, status = ?::meeting_status,
                            meeting_type = ?::meeting_type_enum
                        WHERE id = ?
                     """;
        String location = """
                            UPDATE locations
                            SET city = ?, neighborhood = ?, street = ?, house_number = ?, reference_point = ?
                            WHERE id = (SELECT location_id FROM meetings WHERE id = ?)
                          """;
        try(Connection conn = dbFactory.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql))
        {
            pstmt.setString(1, meeting.getDescription());
            pstmt.setTimestamp(2, Timestamp.valueOf(meeting.getDayTime()));
            pstmt.setString(3, meeting.getStatus());

            if (meeting instanceof FaceToFaceMeeting ftf)
            {
                pstmt.setString(4, "PRESENCIAL");

                try(PreparedStatement locps = conn.prepareStatement(location)) {
                    locps.setString(1, ftf.getLocation().getCity());
                    locps.setString(2, ftf.getLocation().getNeighborhood());
                    locps.setString(3, ftf.getLocation().getStreet());
                    locps.setInt(4, ftf.getLocation().getHouseNumber());
                    locps.setString(5, ftf.getLocation().getReferencePoint());
                    locps.setInt(6, meetingid);
                    locps.executeUpdate(); // executa o update da location
                } catch (Exception e) {
                    System.out.println("falha na conexao da tabela location");
                    throw new RuntimeException(e);
                }

            } else {
                pstmt.setString(4, "ONLINE");
            }

            pstmt.setInt(5, meetingid);
            pstmt.executeUpdate(); // executa o update do meeting

        } catch (RuntimeException | SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteMeeting(int meetingId) {

        String deleteParticipants = "DELETE FROM meeting_participants WHERE meeting_id = ?";
        String deleteLocation = "DELETE FROM locations WHERE id = (SELECT location_id FROM meetings WHERE id = ?)";
        String deleteMeeting = "DELETE FROM meetings WHERE id = ?";

        try (Connection conn = dbFactory.getConnection()) {

            try {
                conn.setAutoCommit(false);

                try (PreparedStatement pstmt = conn.prepareStatement(deleteParticipants)) {
                    pstmt.setInt(1, meetingId);
                    pstmt.executeUpdate();
                }

                try (PreparedStatement pstmt = conn.prepareStatement(deleteLocation)) {
                    pstmt.setInt(1, meetingId);
                    pstmt.executeUpdate();
                }

                try (PreparedStatement pstmt = conn.prepareStatement(deleteMeeting)) {
                    pstmt.setInt(1, meetingId);
                    pstmt.executeUpdate();
                }

                conn.commit();
                System.out.println("meeting deletado com sucesso");

            } catch (SQLException e) {
                conn.rollback();
                System.out.println("falha ao deletar meeting" + e.getMessage());
                throw new RuntimeException(e);
            }

        } catch (SQLException e) {
            System.out.println("falha na conexao com o banco" + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}