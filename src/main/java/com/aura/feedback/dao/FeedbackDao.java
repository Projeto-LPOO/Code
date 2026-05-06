package com.aura.feedback.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.feedback.model.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
            System.out.println("Feedback registrado com sucesso no banco.");

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao salvar feedback: " + e.getMessage(), e);
        }
    }
	
	public boolean hasFeedback(int meetingId) {
	    String sql = "SELECT COUNT(*) FROM feedbacks WHERE meeting_id = ?";
	    try (Connection conn = dbFactory.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, meetingId);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            return rs.getInt(1) > 0; // Se o contador for maior que 0, já existe feedback
	        }
	    } catch (SQLException e) {
	        throw new RuntimeException("Erro ao verificar existência de feedback: " + e.getMessage());
	    }
	    return false;
	}
}
