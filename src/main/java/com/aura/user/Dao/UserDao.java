package com.aura.user.Dao;

import com.aura.dbConfig.dbFactory;
import com.aura.user.Models.CommercialUser;

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

    public List<String> getCommercialUsersName()
    {
        List<String> userNames = new ArrayList<>();
        String sql = "select name from users where type = 'COMMERCIAL'::user_type";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();)
        {
            while (rs.next())
            {
                userNames.add(rs.getString("name"));
            }


        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return userNames;
    }

    public CommercialUser getById(int id)
    {
        CommercialUser commercialUser = null;
        String sql = "select * from users where id = ? and type = 'COMMERCIAL'::user_type";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);)
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

    public List<CommercialUser> getByName(String name)
    {
        List<CommercialUser> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE name LIKE ? AND type = 'COMMERCIAL'::user_type";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);)
        {
            stmt.setString(1, "%" + name + "%");
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
            PreparedStatement stmt = connection.prepareStatement(sql);)
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
