package com.aura.interest;

import java.util.List;

public class InterestController {
    private InterestDAO interestDAO = new InterestDAO();

    public void cadastrarInteresse(InterestModel interest) {
        // Validação simples
        if (interest.getName() == null || interest.getName().isEmpty()) {
            System.out.println(" Erro: O interesse precisa de um nome!");
            return;
        }
        interestDAO.save(interest);
    }

    public List<InterestModel> listarTodos() {
        return interestDAO.findAll();
    }

    public void excluir(int id) {
        interestDAO.delete(id);
    }
}