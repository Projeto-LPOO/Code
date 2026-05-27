package com.aura.profile.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.profile.models.Profile;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ProfileDao {

    public void create(Profile profile) {

        String sql = """
                INSERT INTO profile
                (user_id, bio, city)
                VALUES (?, ?, ?)
                """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)
        ) {

            stmt.setInt(1, profile.getUserId());
            stmt.setString(2, profile.getBio());
            stmt.setString(3, profile.getCity());

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Erro ao criar profile: " + e.getMessage(), e);
        }
    }

    public void update(Profile profile) {

        String sql = """
                UPDATE profile
                SET bio = ?,
                    city = ?
                WHERE user_id = ?
                """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)
        ) {

            stmt.setString(1, profile.getBio());
            stmt.setString(2, profile.getCity());
            stmt.setInt(3, profile.getUserId());

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Erro ao atualizar profile: " + e.getMessage(), e);
        }
    }

    public Profile findByUserId(int userId) {

        String sql = """
                SELECT *
                FROM profile
                WHERE user_id = ?
                """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)
        ) {

            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                Profile profile = new Profile();

                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setBio(rs.getString("bio"));
                profile.setCity(rs.getString("city"));

                return profile;
            }

            return null;

        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar profile: " + e.getMessage(), e);
        }
    }
}