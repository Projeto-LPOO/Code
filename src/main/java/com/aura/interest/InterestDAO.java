package com.aura.interest;

import com.aura.dbConfig.dbFactory;
import com.aura.category.Category; //  para acessar o getId()
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

    public class InterestDAO {

        //create
        public void save(InterestModel interest) {
            String sql = "INSERT INTO public.interests (name, description, interest_type, category_id) VALUES (?, ?, ?, ?)";

            try (Connection conn = dbFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, interest.getName());
                stmt.setString(2, interest.getDescription());
                stmt.setString(3, interest.getType().name()); // salva LEARN  ou SKILL
                stmt.setInt(4, interest.getCategory().getId());
                stmt.executeUpdate();
                System.out.println(" Interesse salvo com sucesso!");

            } catch (SQLException e) {
                System.out.println(" Erro ao salvar interesse: " + e.getMessage());
            }
        }

        //read
        public List<InterestModel> findAll() {
            List<InterestModel> list = new ArrayList<>();
            String sql = "SELECT i.*, c.name as category_name FROM interests i " +
                    "JOIN categories c ON i.category_id = c.id";

            try (Connection conn = dbFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    InterestModel interest = new InterestModel();

                    interest.setIdInterest(rs.getInt("id"));
                    interest.setName(rs.getString("name"));
                    interest.setDescription(rs.getString("description"));

                    String typeStr = rs.getString("interest_type");
                    interest.setType(InterestType.valueOf(typeStr)); //converte para ENU

                    // Cria a categoria
                    Category cat = new Category(rs.getInt("category_id"), rs.getString("category_name"));
                    interest.setCategory(cat);

                    list.add(interest);
                }

                System.out.println("DEBUG: Total de registros encontrados: " + list.size());

            } catch (SQLException e) {
                System.out.println(" Erro ao listar interesses: " + e.getMessage());
            }
            return list;
        }

        //update
        public void update(InterestModel interest) {
            // colunas no id
            String sql = "UPDATE public.interests SET name = ?, description = ?, interest_type = ?, category_id = ? WHERE id = ?";

            try (Connection conn = dbFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, interest.getName());
                stmt.setString(2, interest.getDescription());
                stmt.setString(3, interest.getType().name());
                stmt.setInt(4, interest.getCategory().getId());

                // O WHERE usa o ID para não atualizar a tabela inteira!
                stmt.setInt(5, interest.getIdInterest());

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Interesse ID " + interest.getIdInterest() + " Atualizado com sucesso!");
                } else {
                    System.out.println("Nenhum interesse encontrado com esse ID " + interest.getIdInterest());
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
