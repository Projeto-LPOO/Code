package com.aura.meeting.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.meeting.model.Meeting;
import com.aura.meeting.model.MeetingReport;
import com.aura.meeting.model.ReportStatus;
import com.aura.meeting.model.ReportingMetrics;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.Learner;
import com.aura.user.models.Teacher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportDao {

    public List<MeetingReport> findAllReports() {

        List<MeetingReport> reports = new ArrayList<>();

        String sql = """
                SELECT
                    mr.id AS report_id,
                    mr.reason,
                    mr.status AS report_status,
                    mr.from_user_id,

                    m.id AS meeting_id,
                    m.description,
                    m.status AS meeting_status,
                    m.duration_minutes,
                    m.scheduled_at,

                    learner.id AS learner_id,
                    learner.name AS learner_name,

                    teacher.id AS teacher_id,
                    teacher.name AS teacher_name,

                    reporter.name AS reporter_name

                FROM meeting_reports mr

                INNER JOIN meetings m
                    ON mr.meeting_id = m.id

                INNER JOIN meeting_participants mp_learner
                    ON m.id = mp_learner.meeting_id
                    AND mp_learner.role = 'LEARNER'

                INNER JOIN users learner
                    ON mp_learner.user_id = learner.id

                INNER JOIN meeting_participants mp_teacher
                    ON m.id = mp_teacher.meeting_id
                    AND mp_teacher.role = 'TEACHER'

                INNER JOIN users teacher
                    ON mp_teacher.user_id = teacher.id

                INNER JOIN users reporter
                    ON mr.from_user_id = reporter.id

                ORDER BY mr.id DESC
                """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt =
                        connection.prepareStatement(sql)
        ) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                MeetingReport report = new MeetingReport();

                report.setId(rs.getInt("report_id"));

                report.setReason(rs.getString("reason"));

                report.setStatus(ReportStatus.valueOf(rs.getString("report_status")));

                CommercialUser fromUser = new CommercialUser();

                fromUser.setId(rs.getInt("from_user_id"));

                fromUser.setName(rs.getString("reporter_name"));

                report.setFromUser(fromUser);

                Meeting meeting = new Meeting();

                meeting.setId(rs.getInt("meeting_id"));

                meeting.setDescription(rs.getString("description"));

                meeting.setStatus(rs.getString("meeting_status"));

                meeting.setDurationMinutes(rs.getInt("duration_minutes"));

                meeting.setDayTime(rs.getTimestamp("scheduled_at").toLocalDateTime());

                Learner learner = new Learner();

                learner.setId(rs.getInt("learner_id"));

                learner.setName(rs.getString("learner_name"));

                meeting.setLearner(learner);

                Teacher teacher = new Teacher();

                teacher.setId(rs.getInt("teacher_id"));

                teacher.setName(rs.getString("teacher_name"));

                meeting.setTeacher(teacher);

                report.setMeetingReport(meeting);

                reports.add(report);
            }

        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar reports: " + e.getMessage(), e);
        }

        return reports;
    }

    public void registerReport(int meetingId, int fromUserId, String reason) {

        String sql = """
                    INSERT INTO meeting_reports
                    (meeting_id, from_user_id, reason, status)
                    VALUES (?, ?, ?, ?::report_status)
                """;

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {

            pstmt.setInt(1, meetingId);

            pstmt.setInt(2, fromUserId);

            pstmt.setString(3, reason);

            pstmt.setString(4, ReportStatus.PENDENTE.name());

            pstmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao registrar report: " + e.getMessage(), e
            );
        }
    }

    public boolean hasReportFromUser(int meetingId, int fromUserId) {

        String sql = """
                SELECT COUNT(*)
                FROM meeting_reports
                WHERE meeting_id = ?
                AND from_user_id = ?
                """;

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {

            pstmt.setInt(1, meetingId);

            pstmt.setInt(2, fromUserId);

            ResultSet rs = pstmt.executeQuery();

            return rs.next() && rs.getInt(1) > 0;

        } catch (SQLException e) {

            throw new RuntimeException("Erro ao verificar report: " + e.getMessage(), e
            );
        }
    }

    public void updateReportStatus(int reportId, ReportStatus status) {

        String sql = """
                UPDATE meeting_reports
                SET status = ?
                WHERE id = ?
                """;

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {

            pstmt.setString(1, status.name());

            pstmt.setInt(2, reportId);

            pstmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException("Erro ao atualizar status do report: " + e.getMessage(), e);
        }
    }

    public ReportingMetrics getReportingMetrics() {

        String sql = """
            SELECT
                COUNT(*) AS total,

                COUNT(*) FILTER (
                    WHERE status = 'PENDENTE'
                ) AS pendentes,

                COUNT(*) FILTER (
                    WHERE status = 'EM_ANALISE'
                ) AS em_analise,

                COUNT(*) FILTER (
                    WHERE status = 'RESOLVIDO'
                ) AS resolvidos

            FROM meeting_reports
            """;

        try (
                Connection conn = dbFactory.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql)
        ) {

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                ReportingMetrics stats =
                        new ReportingMetrics();

                stats.setTotal(
                        rs.getInt("total")
                );

                stats.setPendentes(
                        rs.getInt("pendentes")
                );

                stats.setEmAnalise(
                        rs.getInt("em_analise")
                );

                stats.setResolvidos(
                        rs.getInt("resolvidos")
                );

                return stats;
            }

            return new ReportingMetrics();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao buscar estatísticas dos reports",
                    e
            );
        }
    }

    public int findReporterUserId(int meetingId) {
        String sql = "SELECT from_user_id FROM meeting_reports WHERE meeting_id = ? LIMIT 1";
        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, meetingId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() ? rs.getInt(1) : -1;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar reporter: " + e.getMessage(), e);
        }
    }

}