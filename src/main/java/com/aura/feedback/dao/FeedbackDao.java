package com.aura.feedback.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.feedback.model.Feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class FeedbackDao {

	public void registerFeedback(Feedback feedback) {
		String sql = "INSERT INTO feedbacks (meeting_id, from_user_id, to_user_id, rating, comment, date) " +
				"VALUES (?, ?, ?, ?, ?, CURRENT_DATE)";

		try (Connection conn = dbFactory.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, feedback.getMeetingId());
			pstmt.setInt(2, feedback.getFromUserId());
			pstmt.setInt(3, feedback.getToUserId());
			pstmt.setInt(4, feedback.getRating());
			pstmt.setString(5, feedback.getComment());

			pstmt.executeUpdate();

		} catch (SQLException e) {
			throw new RuntimeException("Erro ao salvar feedback: " + e.getMessage(), e);
		}
	}


	// verifica se um usuário específico já avaliou um meeting.
	// permite que aluno e professor avaliem o mesmo meeting independentemente.

	public boolean hasFeedbackFromUser(int meetingId, int fromUserId) {
		String sql = "SELECT COUNT(*) FROM feedbacks WHERE meeting_id = ? AND from_user_id = ?";
		try (Connection conn = dbFactory.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, meetingId);
			pstmt.setInt(2, fromUserId);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			throw new RuntimeException("Erro ao verificar existência de feedback: " + e.getMessage(), e);
		}
		return false;
	}

	// verifica se existe QUALQUER feedback no meeting.
	// @deprecated Use hasFeedbackFromUser para verificação por usuário.
	@Deprecated
	public boolean hasFeedback(int meetingId) {
		String sql = "SELECT COUNT(*) FROM feedbacks WHERE meeting_id = ?";
		try (Connection conn = dbFactory.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, meetingId);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			throw new RuntimeException("Erro ao verificar existência de feedback: " + e.getMessage(), e);
		}
		return false;
	}

    public List<Feedback> findByToUserId(int id) {
        return null;
    }
}