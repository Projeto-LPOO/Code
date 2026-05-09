package com.aura.meeting.dao;

import com.aura.category.Category;
import com.aura.dbConfig.dbFactory;
import com.aura.meeting.model.FaceToFaceMeeting;
import com.aura.meeting.model.Location;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.OnlineMeeting;
import com.aura.user.models.Learner;
import com.aura.user.models.Teacher;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MeetingDao {

    public void register(Meeting meeting) {
        // ALTERADO: adicionado duration_minutes na INSERT
        String sqlMeeting = "INSERT INTO meetings(description, scheduled_at, meeting_type, status, category_id, duration_minutes)" +
                "VALUES(?, ?, ?::meeting_type_enum, ?::meeting_status, ?, ?)";
        String sqlLocation = "INSERT INTO locations(city, neighborhood, street, house_number, reference_point)" +
                "VALUES(?, ?, ?, ?, ?)";
        String sqlParticipantLearner = "INSERT INTO meeting_participants(meeting_id, user_id, role)" +
                "VALUES(?, ?, 'LEARNER'::participant_role)";
        String sqlParticipantTeacher = "INSERT INTO meeting_participants(meeting_id, user_id, role)" +
                "VALUES(?, ?, 'TEACHER'::participant_role)";

        try (Connection conn = dbFactory.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int meetingId = 0;

                try (PreparedStatement pstmt = conn.prepareStatement(sqlMeeting, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setString(1, meeting.getDescription());
                    pstmt.setTimestamp(2, Timestamp.valueOf(meeting.getDayTime()));
                    pstmt.setString(3, meeting instanceof FaceToFaceMeeting ? "PRESENCIAL" : "ONLINE");
                    pstmt.setString(4, "pending");
                    if (meeting.getCategory() != null)
                        pstmt.setInt(5, meeting.getCategory().getId());
                    else
                        pstmt.setNull(5, Types.INTEGER);
                    // NOVO: duração, padrão 60 se não informada
                    int dur = meeting.getDurationMinutes() > 0 ? meeting.getDurationMinutes() : 60;
                    pstmt.setInt(6, dur);
                    pstmt.executeUpdate();

                    ResultSet rs = pstmt.getGeneratedKeys();
                    if (rs.next()) {
                        meetingId = rs.getInt(1);
                        meeting.setId(meetingId);
                    }
                }

                try (PreparedStatement pstmt = conn.prepareStatement(sqlParticipantLearner)) {
                    pstmt.setInt(1, meetingId);
                    pstmt.setInt(2, meeting.getLearner().getId());
                    pstmt.executeUpdate();
                }

                try (PreparedStatement pstmt = conn.prepareStatement(sqlParticipantTeacher)) {
                    pstmt.setInt(1, meetingId);
                    pstmt.setInt(2, meeting.getTeacher().getId());
                    pstmt.executeUpdate();
                }

                if (meeting instanceof FaceToFaceMeeting ftf) {
                    try (PreparedStatement pstmt = conn.prepareStatement(sqlLocation, Statement.RETURN_GENERATED_KEYS)) {
                        pstmt.setString(1, ftf.getLocation().getCity());
                        pstmt.setString(2, ftf.getLocation().getNeighborhood());
                        pstmt.setString(3, ftf.getLocation().getStreet());
                        pstmt.setInt(4, ftf.getLocation().getHouseNumber());
                        pstmt.setString(5, ftf.getLocation().getReferencePoint());
                        pstmt.executeUpdate();

                        ResultSet rs = pstmt.getGeneratedKeys();
                        if (rs.next()) {
                            updateLocationId(conn, meetingId, rs.getInt(1));
                        }
                    }
                }

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException(e);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void updateLocationId(Connection conn, int meetingId, int locationId) {
        String sql = "UPDATE meetings SET location_id = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, locationId);
            pstmt.setInt(2, meetingId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Meeting> findByUserId(int userId) {
        List<Meeting> meetings = new ArrayList<>();

        // ALTERADO: inclui duration_minutes no SELECT
        String sql = "SELECT m.id, m.description, m.scheduled_at, m.status, m.meeting_type, m.duration_minutes, " +
                "c.id AS category_id, c.name AS category_name " +
                "FROM meetings m " +
                "JOIN meeting_participants mp ON mp.meeting_id = m.id " +
                "LEFT JOIN categories c ON c.id = m.category_id " +
                "WHERE mp.user_id = ? " +
                "ORDER BY m.scheduled_at DESC";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Meeting meeting = "PRESENCIAL".equalsIgnoreCase(rs.getString("meeting_type"))
                        ? new FaceToFaceMeeting()
                        : new OnlineMeeting();

                meeting.setId(rs.getInt("id"));
                meeting.setDescription(rs.getString("description"));
                meeting.setStatus(rs.getString("status"));
                meeting.setDayTime(rs.getTimestamp("scheduled_at").toLocalDateTime());
                meeting.setDurationMinutes(rs.getInt("duration_minutes")); // NOVO

                int categoryId = rs.getInt("category_id");
                if (!rs.wasNull()) {
                    Category category = new Category();
                    category.setId(categoryId);
                    category.setName(rs.getString("category_name"));
                    meeting.setCategory(category);
                }

                meetings.add(meeting);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return meetings;
    }

    public List<Meeting> findAll() {
        List<Meeting> meetings = new ArrayList<>();
        // ALTERADO: inclui duration_minutes
        String sql = "SELECT m.id, m.description, m.scheduled_at, m.status, m.meeting_type, m.duration_minutes, " +
                "c.id AS category_id, c.name AS category_name " +
                "FROM meetings m " +
                "LEFT JOIN categories c ON c.id = m.category_id " +
                "ORDER BY m.scheduled_at DESC";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Meeting meeting = "PRESENCIAL".equalsIgnoreCase(rs.getString("meeting_type"))
                        ? new FaceToFaceMeeting()
                        : new OnlineMeeting();

                meeting.setId(rs.getInt("id"));
                meeting.setDescription(rs.getString("description"));
                meeting.setStatus(rs.getString("status"));
                meeting.setDayTime(rs.getTimestamp("scheduled_at").toLocalDateTime());
                meeting.setDurationMinutes(rs.getInt("duration_minutes")); // NOVO

                int categoryId = rs.getInt("category_id");
                if (!rs.wasNull()) {
                    Category category = new Category();
                    category.setId(categoryId);
                    category.setName(rs.getString("category_name"));
                    meeting.setCategory(category);
                }

                meetings.add(meeting);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return meetings;
    }

    public Meeting findById(int meetingId) {
        // ALTERADO: inclui duration_minutes
        String sql = "SELECT m.*, c.id AS category_id, c.name AS category_name " +
                "FROM meetings m " +
                "LEFT JOIN categories c ON c.id = m.category_id " +
                "WHERE m.id = ?";
        String sqlLocation = "SELECT * FROM locations WHERE id = (SELECT location_id FROM meetings WHERE id = ?)";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             PreparedStatement locps = conn.prepareStatement(sqlLocation)) {

            pstmt.setInt(1, meetingId);
            locps.setInt(1, meetingId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String tipo = rs.getString("meeting_type");
                Meeting meeting;

                if ("PRESENCIAL".equalsIgnoreCase(tipo)) {
                    FaceToFaceMeeting ftf = new FaceToFaceMeeting();
                    ftf.setId(meetingId);
                    ftf.setDescription(rs.getString("description"));
                    ftf.setStatus(rs.getString("status"));
                    ftf.setDayTime(rs.getTimestamp("scheduled_at").toLocalDateTime());
                    ftf.setDurationMinutes(rs.getInt("duration_minutes")); // NOVO

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
                    om.setDurationMinutes(rs.getInt("duration_minutes")); // NOVO
                    meeting = om;
                }

                int categoryId = rs.getInt("category_id");
                if (!rs.wasNull()) {
                    Category category = new Category();
                    category.setId(categoryId);
                    category.setName(rs.getString("category_name"));
                    meeting.setCategory(category);
                }

                loadParticipants(conn, meeting);

                return meeting;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    private void loadParticipants(Connection conn, Meeting meeting) throws SQLException {
        String sql = "SELECT u.id, u.name, mp.role FROM meeting_participants mp " +
                "JOIN users u ON u.id = mp.user_id WHERE mp.meeting_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, meeting.getId());
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String role = rs.getString("role");
                if ("LEARNER".equals(role)) {
                    Learner learner = new Learner();
                    learner.setId(rs.getInt("id"));
                    learner.setName(rs.getString("name"));
                    meeting.setLearner(learner);
                } else if ("TEACHER".equals(role)) {
                    Teacher teacher = new Teacher();
                    teacher.setId(rs.getInt("id"));
                    teacher.setName(rs.getString("name"));
                    meeting.setTeacher(teacher);
                }
            }
        }
    }

    public void update(Meeting meeting) {
        int meetingId = meeting.getId();

        String sql = "UPDATE meetings SET description = ?, scheduled_at = ?, status = ?::meeting_status," +
                " meeting_type = ?::meeting_type_enum WHERE id = ?";
        String sqlLocation = "UPDATE locations SET city = ?, neighborhood = ?, street = ?," +
                " house_number = ?, reference_point = ? WHERE id =" +
                " (SELECT location_id FROM meetings WHERE id = ?)";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, meeting.getDescription());
            pstmt.setTimestamp(2, Timestamp.valueOf(meeting.getDayTime()));
            pstmt.setString(3, meeting.getStatus());

            if (meeting instanceof FaceToFaceMeeting ftf) {
                pstmt.setString(4, "PRESENCIAL");
                try (PreparedStatement locps = conn.prepareStatement(sqlLocation)) {
                    locps.setString(1, ftf.getLocation().getCity());
                    locps.setString(2, ftf.getLocation().getNeighborhood());
                    locps.setString(3, ftf.getLocation().getStreet());
                    locps.setInt(4, ftf.getLocation().getHouseNumber());
                    locps.setString(5, ftf.getLocation().getReferencePoint());
                    locps.setInt(6, meetingId);
                    locps.executeUpdate();
                }
            } else {
                pstmt.setString(4, "ONLINE");
            }

            pstmt.setInt(5, meetingId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int meetingId) {
        String deleteParticipants = "DELETE FROM meeting_participants WHERE meeting_id = ?";
        String deleteLocation = "DELETE FROM locations WHERE id = (SELECT location_id FROM meetings WHERE id = ?)";
        String deleteMeeting = "DELETE FROM meetings WHERE id = ?";

        try (Connection conn = dbFactory.getConnection()) {
            conn.setAutoCommit(false);
            try {
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
            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException(e);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean hasConflict(int teacherId, LocalDateTime scheduledAt) {
        String sql = "SELECT COUNT(*) FROM meetings m " +
                "JOIN meeting_participants mp ON mp.meeting_id = m.id " +
                "WHERE mp.user_id = ? AND mp.role = 'TEACHER'::participant_role " +
                "AND m.status NOT IN ('cancelled') " +
                "AND DATE(m.scheduled_at) = DATE(?) " +
                "AND m.scheduled_at = ?";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, teacherId);
            stmt.setTimestamp(2, Timestamp.valueOf(scheduledAt));
            stmt.setTimestamp(3, Timestamp.valueOf(scheduledAt));

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error checking meeting conflict: " + e.getMessage(), e);
        }
        return false;
    }
}