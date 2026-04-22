package com.aura.user.Dao;

import com.aura.dbConfig.dbFactory;
import com.aura.user.Models.Admin;
import com.aura.user.Models.CommercialUser;
import com.aura.user.Models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public void registerUser(CommercialUser usuario)
    {
        String sql = "INSERT INTO users(name, age, address, phone, cpf, email, password, type, updated_at) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, 'COMMERCIAL'::user_type, ?)";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setString(1, usuario.getName());
            stmt.setInt(2, usuario.getAge());
            stmt.setString(3, usuario.getAddress());
            stmt.setString(4, usuario.getPhone());
            stmt.setString(5, usuario.getCpf());
            stmt.setString(6, usuario.getEmail());
            stmt.setString(7, usuario.getHashPassword());
            stmt.setTimestamp(8, usuario.getUpdatedAt());
            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<CommercialUser> findAll()
    {
        List<CommercialUser> commercialUsers = new ArrayList<>();

        String sql = "select * from users where type = 'COMMERCIAL'::user_type";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery())
        {
            while (rs.next())
            {
                CommercialUser commercialUser = new CommercialUser();
                commercialUser.setId(rs.getInt("id"));
                commercialUser.setName(rs.getString("name"));
                commercialUser.setAge(rs.getInt("age"));
                commercialUser.setAddress(rs.getString("address"));
                commercialUser.setPhone(rs.getString("phone"));
                commercialUser.setCpf(rs.getString("cpf"));
                commercialUser.setEmail(rs.getString("email"));
                commercialUser.setHashPassword(rs.getString("password"));

                commercialUsers.add(commercialUser);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return commercialUsers;
    }

    public CommercialUser findById(int id)
    {
        CommercialUser commercialUser = null;
        String sql = "select * from users where id = ? and type = 'COMMERCIAL'::user_type";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next())
            {
                commercialUser = new CommercialUser();
                commercialUser.setId(id);
                commercialUser.setName(rs.getString("name"));
                commercialUser.setAge(rs.getInt("age"));
                commercialUser.setAddress(rs.getString("address"));
                commercialUser.setPhone(rs.getString("phone"));
                commercialUser.setCpf(rs.getString("cpf"));
                commercialUser.setEmail(rs.getString("email"));
                commercialUser.setHashPassword(rs.getString("password"));

                stmt.execute();
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return commercialUser;
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

                if (type.equals("ADMIN")) {
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
                user.setHashPassword(rs.getString("password")); // hash do banco
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return user;
    }

    public List<CommercialUser> findByName(String name)
    {
        //agr buscar se o nome é igual ao nome do usuario ou nome do interesse, mas precisa atualizar o metodo
        // de listar users pra aparecer os interests
        List<CommercialUser> users = new ArrayList<>();
        String sql = "SELECT u.*\n" +
                "FROM users u\n" +
                "WHERE LOWER(u.name) LIKE LOWER(?)\n" +
                "  AND u.type = 'COMMERCIAL'::user_type\n" +
                "\n" +
                "UNION\n" +
                "\n" +
                "SELECT u.*\n" +
                "FROM users u\n" +
                "JOIN user_interests ui ON ui.user_id = u.id\n" +
                "JOIN interests i ON i.id = ui.interest_id\n" +
                "WHERE LOWER(i.name) LIKE LOWER(?)\n" +
                "  AND u.type = 'COMMERCIAL'::user_type;";


        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setString(1, "%" + name + "%");
            stmt.setString(2, "%" + name + "%");

            ResultSet rs = stmt.executeQuery();

            while (rs.next())
            {
                CommercialUser commercialUser = new CommercialUser();
                commercialUser.setId(rs.getInt("id"));
                commercialUser.setName(rs.getString("name"));
                commercialUser.setAge(rs.getInt("age"));
                commercialUser.setAddress(rs.getString("address"));
                commercialUser.setPhone(rs.getString("phone"));
                commercialUser.setCpf(rs.getString("cpf"));
                commercialUser.setEmail(rs.getString("email"));
                commercialUser.setHashPassword(rs.getString("password"));

                users.add(commercialUser);
            }


        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return users;
    }
    public void deleteUser(int id)
    {
        String sql = "Delete from users where id = ?";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, id);

            int rowsAffects = stmt.executeUpdate();

            if (rowsAffects > 0)
            {
                System.out.println("Usuario deletado com sucesso!");
            }
            else {
                System.out.println("Não foi encontrado nenhum usuario com esse id");
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void updateUser(CommercialUser commercialUser)
    {
        String sql = "UPDATE users SET name = ?, address = ?, phone = ? WHERE id = ?";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setString(1, commercialUser.getName());
            stmt.setString(2, commercialUser.getAddress());
            stmt.setString(3, commercialUser.getPhone());
            stmt.setInt(4, commercialUser.getId());

            stmt.executeUpdate();
            System.out.println("Sucesso");

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
