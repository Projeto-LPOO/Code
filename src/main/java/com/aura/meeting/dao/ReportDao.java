package com.aura.meeting.dao;

import com.aura.category.Category;
import com.aura.dbConfig.dbFactory;
import com.aura.meeting.model.*;
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
                    mr.status AS report_status,
                    mr.report_category,
                    mr.description AS report_description,
                    mr.from_user_id,

                    m.id AS meeting_id,
                    m.description AS meeting_description,
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

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql))
         {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                MeetingReport report = new MeetingReport();

                report.setId(rs.getInt("report_id"));
                report.setCategory(ReportCategory.valueOf(rs.getString("report_category")));
                report.setStatus(rs.getBoolean("report_status"));
                report.setDescription(rs.getString("report_description"));


                CommercialUser fromUser = new CommercialUser();

                fromUser.setId(rs.getInt("from_user_id"));

                fromUser.setName(rs.getString("reporter_name"));

                report.setFromUser(fromUser);

                Meeting meeting = new Meeting();

                meeting.setId(rs.getInt("meeting_id"));

                meeting.setDescription(rs.getString("meeting_description"));

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

    public List<MeetingReport> findAllReportsByUser(int userId) {

        List<MeetingReport> reports = new ArrayList<>();

        String sql = """
            SELECT
                mr.id AS report_id,
                mr.status AS report_status,
                mr.report_category,
                mr.description AS report_description,
                mr.from_user_id,

                m.id AS meeting_id,
                m.description AS meeting_description,
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
                        
             WHERE (
                 learner.id = ?
                 OR teacher.id = ?
             )
                 
            AND mr.from_user_id != ?

            ORDER BY mr.id DESC
            """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt =
                        connection.prepareStatement(sql)
        ) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                MeetingReport report = new MeetingReport();

                report.setId(rs.getInt("report_id"));
                report.setCategory(ReportCategory.valueOf(rs.getString("report_category")));

                report.setStatus(rs.getBoolean("report_status"));

                report.setDescription(rs.getString("report_description"));

                CommercialUser fromUser = new CommercialUser();

                fromUser.setId(rs.getInt("from_user_id"));

                fromUser.setName(rs.getString("reporter_name"));

                report.setFromUser(fromUser);

                Meeting meeting = new Meeting();

                meeting.setId(rs.getInt("meeting_id"));

                meeting.setDescription(rs.getString("meeting_description"));

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
            throw new RuntimeException(
                    "Erro ao buscar reports: " + e.getMessage(),
                    e
            );
        }
        return reports;
    }


    public int findUserReportNumber(int userId) {

        String sql = """
            SELECT COUNT(*)
            FROM meeting_reports mr
            INNER JOIN meeting_participants mp
                ON mp.meeting_id = mr.meeting_id
            WHERE mp.user_id = ?
              AND mp.user_id != mr.from_user_id
            AND mr.report_category = 'NAO_COMPARECEU'
            """;

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return 0;
    }

    public void registerReport(int meetingId, int fromUserId, ReportCategory category, String description) {

        String sql = """
                    INSERT INTO meeting_reports
                    (meeting_id, from_user_id, report_category, description, status)
                    VALUES (?, ?, ?::report_category, ? , ?)
                """;

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {

            pstmt.setInt(1, meetingId);

            pstmt.setInt(2, fromUserId);

            pstmt.setString(3, category.name());

            pstmt.setString(4, description);

            pstmt.setBoolean(5, false);

            pstmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException( "Erro ao registrar report: " + e.getMessage(), e);
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

    public void updateReportStatus(int reportId) {

        String sql = """
                UPDATE meeting_reports
                SET status = ?
                WHERE id = ?
                """;

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {

            pstmt.setBoolean(1, true);

            pstmt.setInt(2, reportId);

            pstmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException("Erro ao atualizar status do report: " + e.getMessage(), e);
        }
    }

    public ReportingMetrics getReportingMetrics() {

        String sql = """
            SELECT
                (
                SELECT COUNT(*)
                    FROM meeting_reports
                ) AS total_reports,
        
                COUNT(*) AS total_evidences,
        
                COUNT(*) FILTER (
                    WHERE evidence_accepted = 'PENDENTE'
                ) AS pendentes,
        
                COUNT(*) FILTER (
                    WHERE evidence_accepted = 'ACEITO'
                ) AS aceitos,
        
                COUNT(*) FILTER (
                    WHERE evidence_accepted = 'RECUSADO'
                ) AS recusados
        
            FROM report_evidences
        """;

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql))
        {
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                ReportingMetrics stats = new ReportingMetrics();

                stats.setTotalReports(rs.getInt("total_reports"));
                stats.setTotalEvidences(rs.getInt("total_evidences"));
                stats.setPendentes(rs.getInt("pendentes"));
                stats.setResolvidos(rs.getInt("aceitos"));
                stats.setRecusados(rs.getInt("recusados"));

                return stats;
            }

            return new ReportingMetrics();

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar estatísticas dos reports", e);
        }
    }
    public MeetingReport findReportById(int reportId) {

        String sql = """
            SELECT
                mr.id AS report_id,
                mr.status AS report_status,
                mr.report_category,
                mr.description AS report_description,
                mr.from_user_id,

                m.id AS meeting_id,
                m.description AS meeting_description,
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

            WHERE mr.id = ?
            """;

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql))
        {

            stmt.setInt(1, reportId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                MeetingReport report = new MeetingReport();

                report.setId(rs.getInt("report_id"));
                report.setCategory(ReportCategory.valueOf(rs.getString("report_category")));
                report.setStatus(rs.getBoolean("report_status"));
                report.setDescription(rs.getString("report_description"));

                CommercialUser fromUser = new CommercialUser();
                fromUser.setId(rs.getInt("from_user_id"));

                fromUser.setName(rs.getString("reporter_name"));
                report.setFromUser(fromUser);

                Meeting meeting = new Meeting();
                meeting.setId(rs.getInt("meeting_id"));
                meeting.setDescription(rs.getString("meeting_description"));
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

                return report;
            }

        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar report por ID: " + e.getMessage(), e);}

        return null;
    }

    public void registerEvidence(ReportEvidence evidence) {

        String sql = """
            INSERT INTO report_evidences
            (
                report_id,
                user_id,
                description,
                image_path,
                evidence_accepted
            )
            VALUES (?, ?, ?, ?, ?::evidence_accepted)
            """;

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql))
        {

            stmt.setInt(1, evidence.getReport().getId());
            stmt.setInt(2, evidence.getUser().getId());
            stmt.setString(3, evidence.getDescription());
            stmt.setString(4, evidence.getImagePath());
            stmt.setString(5, EvidenceAccepted.PENDENTE.name());
            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Erro ao criar comprovação: " + e.getMessage(), e);
        }
    }
    public List<ReportEvidence> findAllEvidenceAdminView() {

        String sql = """
    SELECT
        re.id AS evidence_id,
        re.description AS evidence_description,
        re.image_path AS evidence_image_path,
        re.created_at AS evidence_created_at,
        re.evidence_accepted,

        mr.id AS report_id,
        mr.report_category,
        mr.status AS report_status,
        mr.description AS report_description,
        mr.created_at AS report_created_at,
        mr.from_user_id,

        reporter.name AS reporter_name,
        reporter.email AS reporter_email,

        m.id AS meeting_id,
        m.description AS meeting_description,
        m.status AS meeting_status,
        m.scheduled_at AS meeting_date,
        m.duration_minutes,

        learner.name AS learner_name,
        teacher.name AS teacher_name,

        u.id AS user_id,
        u.name AS user_name,
        u.email AS user_email

    FROM report_evidences re

    JOIN meeting_reports mr
        ON mr.id = re.report_id

    JOIN users reporter
        ON reporter.id = mr.from_user_id

    JOIN meetings m
        ON m.id = mr.meeting_id

    JOIN meeting_participants mp_learner
        ON mp_learner.meeting_id = m.id
        AND mp_learner.role = 'LEARNER'

    JOIN users learner
        ON learner.id = mp_learner.user_id

    JOIN meeting_participants mp_teacher
        ON mp_teacher.meeting_id = m.id
        AND mp_teacher.role = 'TEACHER'

    JOIN users teacher
        ON teacher.id = mp_teacher.user_id

    JOIN users u
        ON u.id = re.user_id

    ORDER BY re.created_at DESC
    """;

        List<ReportEvidence> list = new ArrayList<>();

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    ReportEvidence evidence = new ReportEvidence();

                    evidence.setId(rs.getInt("evidence_id"));
                    evidence.setDescription(rs.getString("evidence_description"));
                    evidence.setImagePath(rs.getString("evidence_image_path"));
                    evidence.setAccepted(EvidenceAccepted.valueOf(rs.getString("evidence_accepted")));
                    evidence.setCreatedAt(rs.getTimestamp("evidence_created_at"));


                    MeetingReport report = new MeetingReport();
                    report.setId(rs.getInt("report_id"));
                    report.setDescription(rs.getString("report_description"));
                    report.setStatus(rs.getBoolean("report_status"));
                    report.setCategory(ReportCategory.valueOf(rs.getString("report_category")));

                    Meeting meeting = new Meeting();
                    meeting.setId(rs.getInt("meeting_id"));
                    meeting.setDescription(rs.getString("meeting_description"));
                    meeting.setStatus(rs.getString("meeting_status"));
                    meeting.setDayTime(rs.getTimestamp("meeting_date").toLocalDateTime());
                    meeting.setDurationMinutes(rs.getInt("duration_minutes"));
                    report.setMeetingReport(meeting);
                    evidence.setReport(report);

                    Learner learner = new Learner();
                    learner.setName(rs.getString("learner_name"));

                    Teacher teacher = new Teacher();
                    teacher.setName(rs.getString("teacher_name"));

                    meeting.setLearner(learner);
                    meeting.setTeacher(teacher);

                    CommercialUser reporter = new CommercialUser();

                    reporter.setId(rs.getInt("from_user_id"));
                    reporter.setName(rs.getString("reporter_name"));
                    reporter.setEmail(rs.getString("reporter_email"));
                    report.setFromUser(reporter);

                    CommercialUser user = new CommercialUser();
                    user.setId(rs.getInt("user_id"));
                    user.setName(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));

                    evidence.setUser(user);

                    list.add(evidence);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar todas as evidências (admin view): " + e.getMessage(), e);
        }
        return list;
    }

    public void updateEvidenceAccept(int id, EvidenceAccepted accepted)
    {
        String sql = "Update report_evidences SET evidence_accepted = ?::evidence_accepted WHERE id = ?";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setString(1, accepted.name());
            stmt.setInt(2, id);
            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }


    }
