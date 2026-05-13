package com.aura.interest.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.category.Category;
import com.aura.interest.model.Interest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

    public class InterestDao {

        public void register(Interest interest) {
            String sql = "INSERT INTO interests (name, category_id) VALUES (?, ?)";

            try (Connection connection = dbFactory.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql)) {

                stmt.setString(1, interest.getName());
                stmt.setInt(4, interest.getCategory().getId());
                stmt.executeUpdate();
                System.out.println(" Interesse salvo com sucesso!");

            } catch (SQLException e) {
                System.out.println(" Erro ao salvar interesse: " + e.getMessage());
            }
        }

        public Interest findById(int id)
        {
            Interest interest = null;
            String sql = "SELECT i.*, c.* " +
                         "FROM interests i " +
                         "INNER JOIN categories c " +
                         "ON c.id = i.category_id " +
                         "WHERE i.id = ?";

            try(Connection connection = dbFactory.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql);)
            {
                stmt.setInt(1, id);

                ResultSet rs = stmt.executeQuery();

                if (rs.next())
                {
                    interest = new Interest();
                    interest.setId(rs.getInt("id"));
                    interest.setName(rs.getString("name"));

                    Category category = new Category();
                    category.setId(rs.getInt("id"));
                    category.setName(rs.getString("name"));
                    interest.setCategory(category);

                    stmt.execute();
                }

            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            return interest;
        }

        public List<Interest> findAll() {

            List<Interest> interests = new ArrayList<>();

            String sql = "SELECT i.*, c.id as \"id_category\", c.name as \"name_category\" \n" +
                         "FROM interests i \n" +
                         "JOIN categories c \n" +
                         "ON i.category_id = c.id";

            try (Connection connection = dbFactory.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Interest interest = new Interest();

                    interest.setId(rs.getInt("id"));
                    interest.setName(rs.getString("name"));

                    Category category = new Category();
                    category.setId(rs.getInt("id_category"));
                    category.setName(rs.getString("name_category"));
                    interest.setCategory(category);

                    interests.add(interest);
                }

                System.out.println("DEBUG: Total de registros encontrados: " + interests.size());

            } catch (SQLException e) {
                System.out.println(" Erro ao listar interesses: " + e.getMessage());
            }
            return interests;
        }

        //update
        public void update(Interest interest) {
            String sql = "UPDATE public.interests SET name = ?, category_id = ? WHERE id = ?";

            try (Connection conn = dbFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, interest.getName());
                stmt.setInt(4, interest.getCategory().getId());

                stmt.setInt(5, interest.getId());

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Interesse ID " + interest.getId() + " Atualizado com sucesso!");
                } else {
                    System.out.println("Nenhum interesse encontrado com esse ID " + interest.getId());
                }

            } catch (SQLException e) {
                System.out.println(" Erro ao atualizar interesse: " + e.getMessage());
            }
        }

        //delete
        public void delete(int idInterest) {
            String sql = "DELETE FROM public.interests WHERE id = ?";

            try (Connection conn = dbFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, idInterest);

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Interesse ID " + idInterest + " excluído com sucesso!");
                } else {
                    System.out.println("Nenhum interesse encontrado com o ID " + idInterest);
                }

            } catch (SQLException e) {
                System.out.println("Erro ao excluir interesse: " + e.getMessage());
            }
        }
    }

