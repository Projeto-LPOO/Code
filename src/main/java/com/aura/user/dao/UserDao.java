package com.aura.user.dao;

import com.aura.category.Category;
import com.aura.dbConfig.dbFactory;
import com.aura.financial.models.Credits;
import com.aura.interest.model.Interest;
import com.aura.user.models.Admin;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public CommercialUser registerUser(CommercialUser usuario) {
        String sql = "INSERT INTO users(name, age, address, phone, cpf, email, password, type, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'COMMERCIAL'::user_type, ?) RETURNING id";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, usuario.getName());
            stmt.setInt(2, usuario.getAge());
            stmt.setString(3, usuario.getAddress());
            stmt.setString(4, usuario.getPhone());
            stmt.setString(5, usuario.getCpf());
            stmt.setString(6, usuario.getEmail());
            stmt.setString(7, usuario.getHashPassword());
            stmt.setTimestamp(8, usuario.getUpdatedAt());

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                usuario.setId(rs.getInt("id"));
            }

            return usuario;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<CommercialUser> findAll() {
        List<CommercialUser> users = new ArrayList<>();

        String sql = "SELECT " +
                "u.id AS user_id, " +
                "u.name AS user_name, " +
                "u.age, " +
                "u.address, " +
                "u.phone, " +
                "u.cpf, " +
                "u.email, " +
                "u.password, " +
                "i.id AS interest_id, " +
                "i.name AS interest_name " +
                "FROM users u " +
                "LEFT JOIN user_interests ui ON ui.user_id = u.id " +
                "LEFT JOIN interests i ON i.id = ui.interest_id " +
                "WHERE u.type = 'COMMERCIAL'::user_type";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                // Chamada do método auxiliar para evitar repetição de código
                mapResultSetToCommercialUser(rs, users);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return users;
    }

    public List<CommercialUser> findByName(String name) {
        List<CommercialUser> users = new ArrayList<>();
        String sql = "SELECT " +
                "u.id AS user_id, " +
                "u.name AS user_name, " +
                "u.age, " +
                "u.address, " +
                "u.phone, " +
                "u.cpf, " +
                "u.email, " +
                "u.password, " +
                "i.id AS interest_id, " +
                "i.name AS interest_name " +
                "FROM users u " +
                "LEFT JOIN user_interests ui ON ui.user_id = u.id " +
                "LEFT JOIN interests i ON i.id = ui.interest_id " +
                "WHERE (LOWER(u.name) LIKE LOWER(?) OR LOWER(i.name) LIKE LOWER(?)) " +
                "AND u.type = 'COMMERCIAL'::user_type";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, "%" + name + "%");
            stmt.setString(2, "%" + name + "%");

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                mapResultSetToCommercialUser(rs, users);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return users;
    }

    public CommercialUser findById(int id)
    {
        List<CommercialUser> users = new ArrayList<>();

        String sql = "SELECT " +
                "u.id AS user_id, " +
                "u.name AS user_name, " +
                "u.age, " +
                "u.address, " +
                "u.phone, " +
                "u.cpf, " +
                "u.email, " +
                "u.password, " +
                "i.id AS interest_id, " +
                "i.name AS interest_name " +
                "FROM users u " +
                "LEFT JOIN user_interests ui ON ui.user_id = u.id " +
                "LEFT JOIN interests i ON i.id = ui.interest_id " +
                "WHERE u.id = ? " +
                "AND u.type = 'COMMERCIAL'::user_type";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                mapResultSetToCommercialUser(rs, users);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return users.isEmpty() ? null : users.get(0);
    }

    public User findByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String type = rs.getString("type");

                if ("ADMIN".equals(type)) {
                    user = new Admin();
                } else {
                    user = new CommercialUser();
                }

                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setAge(rs.getInt("age"));
                user.setAddress(rs.getString("address"));
                user.setPhone(rs.getString("phone"));
                user.setCpf(rs.getString("cpf"));
                user.setEmail(rs.getString("email"));
                user.setHashPassword(rs.getString("password"));
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return user;
    }

    public void deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void updateUser(CommercialUser commercialUser) {
        String sql = "UPDATE users SET name = ?, address = ?, phone = ? WHERE id = ?";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, commercialUser.getName());
            stmt.setString(2, commercialUser.getAddress());
            stmt.setString(3, commercialUser.getPhone());
            stmt.setInt(4, commercialUser.getId());

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    private void mapResultSetToCommercialUser(ResultSet rs, List<CommercialUser> list) throws Exception {
        int userId = rs.getInt("user_id");
        // Verifica se o usuário já foi adicionado à lista (importante para o LEFT JOIN de interesses)
        CommercialUser user = null;
        for (CommercialUser u : list) {
            if (u.getId() == userId) {
                user = u;
                break;
            }
        }

        // Se o usuário ainda não está na lista, cria um novo objeto
        if (user == null) {
            user = new CommercialUser();
            user.setId(userId);
            user.setName(rs.getString("user_name"));
            user.setAge(rs.getInt("age"));
            user.setAddress(rs.getString("address"));
            user.setPhone(rs.getString("phone"));
            user.setCpf(rs.getString("cpf"));
            user.setEmail(rs.getString("email"));
            user.setHashPassword(rs.getString("password"));
            list.add(user);
        }

        // Adiciona o interesse ao usuário se ele existir nesta linha
        if (rs.getString("interest_name") != null) {
            Interest interest = new Interest();
            interest.setId(rs.getInt("interest_id"));
            interest.setName(rs.getString("interest_name"));
            user.getInterests().add(interest);
        }
    }


    public CommercialUser findByIdWithInterests(int id) {
        CommercialUser user = null;

        String sql = "SELECT " +
                "u.id AS user_id, u.name AS user_name, u.age, u.address, u.phone, u.cpf, u.email, u.password, " +
                "i.id AS interest_id, i.name AS interest_name, " +
                "c.id AS category_id, c.name AS category_name " +
                "FROM users u " +
                "LEFT JOIN user_interests ui ON ui.user_id = u.id " +
                "LEFT JOIN interests i ON i.id = ui.interest_id " +
                "LEFT JOIN categories c ON c.id = i.category_id " +
                "WHERE u.id = ? AND u.type = 'COMMERCIAL'::user_type";

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                if (user == null) {
                    user = buildCommercialUser(rs, id);
                }
                appendInterest(rs, user);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return user;
    }

    private CommercialUser findInList(List<CommercialUser> list, int userId) {
        for (CommercialUser u : list) {
            if (u.getId() == userId) return u;
        }
        return null;
    }

    private CommercialUser buildCommercialUser(ResultSet rs, int userId) throws Exception {
        CommercialUser user = new CommercialUser();
        user.setId(userId);
        user.setName(rs.getString("user_name"));
        user.setAge(rs.getInt("age"));
        user.setAddress(rs.getString("address"));
        user.setPhone(rs.getString("phone"));
        user.setCpf(rs.getString("cpf"));
        user.setEmail(rs.getString("email"));
        user.setHashPassword(rs.getString("password"));
        return user;
    }

    private void appendInterest(ResultSet rs, CommercialUser user) throws Exception {
        String interestName = rs.getString("interest_name");
        if (interestName == null) return;

        Interest interest = new Interest();
        interest.setId(rs.getInt("interest_id"));
        interest.setName(interestName);

        int categoryId = rs.getInt("category_id");
        if (!rs.wasNull()) {
            Category category = new Category();
            category.setId(categoryId);
            category.setName(rs.getString("category_name"));
            interest.setCategory(category);
        }

        user.getInterests().add(interest);
    }
}