package com.aura.profile.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.profile.models.Profile;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ProfileDao {

    // Método para buscar os dados que vão preencher o Perfil do usuário
    public Profile findByUserId(int userId) {
        // Busca direto da tabela 'users'
        String sql = """
                SELECT id, name, email, phone, bio 
                FROM public.users 
                WHERE id = ?
                """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)
        ) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Profile profile = new Profile();

                // Mapea os dados da tabela 'users' para o seu modelo de Profile
                profile.setUserId(rs.getInt("id"));
                profile.setName(rs.getString("name"));
                profile.setEmail(rs.getString("email"));
                profile.setPhone(rs.getString("phone"));
                profile.setBio(rs.getString("bio")); //

                return profile;
            }

            return null;

        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar dados do perfil: " + e.getMessage(), e);
        }
    }

    // Método para atualizar apenas a Bio do usuário quando ele editar o perfil
    public void updateBio(int userId, String newBio) {
        String sql = """
                UPDATE public.users 
                SET bio = ?, 
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """;

        try (
                Connection connection = dbFactory.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)
        ) {

            stmt.setString(1, newBio);
            stmt.setInt(2, userId);

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Erro ao atualizar a bio do perfil: " + e.getMessage(), e);
        }
    }
}