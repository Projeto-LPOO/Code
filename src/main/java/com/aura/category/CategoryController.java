package com.aura.category;

import java.util.List;

    public class CategoryController {
        private CategoryDAO dao = new CategoryDAO();

        public void salvar(String nome) {
            // O Controller cria o Model e manda pro DAO
            Category nova = new Category(nome);
            dao.save(nova);
        }

        public List<Category> listar() {
            return dao.findAll();
        }
    }
