package com.aura.category;

import com.aura.dbConfig.dbFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

public class CategoryDAO {

    //create
    public void save(Category category) {
        String sql = "INSERT INTO categories (name) VALUES (?)";

        // usando o try-with resources
        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getName());

            stmt.executeUpdate();
            System.out.println("Categoria salva com sucesso!");

        } catch (SQLException e) {
            System.out.println("Erro ao salvar categoria!" + e.getMessage());
        }
    }

    //read
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM public.categories ORDER BY name";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) { // executeQuery é para busca

            while (rs.next()) {
                Category cat = new Category(1, "Educação");
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                categories.add(cat);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar categorias: " + e.getMessage());
        }
        return categories;
    }

    //update
    public void update(Category category) {
        String sql = "UPDATE public.categories SET name = ? WHERE id = ?";

        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getName());
            stmt.setInt(2, category.getId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Categoria atualizada com sucesso!");
            }

        } catch (SQLException e) {
            System.out.println(" Erro ao atualizar categoria: " + e.getMessage());
        }
    }

    //delete
        public void delete(int id) {
            String sql = "DELETE FROM public.categories WHERE id = ?";

            try (Connection conn = dbFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, id);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    System.out.println(" Categoria excluída com sucesso!");
                }

            } catch (SQLException e) {
                System.out.println(" Erro ao excluir categoria: " + e.getMessage());
            }
        }
}