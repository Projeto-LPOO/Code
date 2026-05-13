package com.aura.category;

import java.util.List;

    public class CategoryController {
        private CategoryDao dao = new CategoryDao();

        public void register(String nome) {
            Category nova = new Category(nome);
            dao.register(nova);
        }

        public List<Category> listar() {return dao.findAll();}
    }
