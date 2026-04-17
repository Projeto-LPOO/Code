package com.aura.user.Controllers;



import com.aura.user.Dao.UserDao;
import com.aura.user.Models.CommercialUser;

import java.util.List;

public class UserController {
    private UserDao userDao = new UserDao();

    public void registerUsuario(String name, int age, String address, String phone,
                                String cpf, String email, String hashPassword)
    {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Nome é obrigatório.");
        }

        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email é obrigatório.");
        }
        if (!email.contains("@")) {
            throw new IllegalArgumentException("Email inválido.");
        }

        if (hashPassword == null || hashPassword.length() < 6) {
            throw new IllegalArgumentException("A senha deve ter pelo menos 6 caracteres.");
        }

        if (age < 16 || age > 100) {
            throw new IllegalArgumentException("Idade inválida.");
        }

        if (cpf == null || cpf.trim().isEmpty()) {
            throw new IllegalArgumentException("CPF é obrigatório.");
        }
        if (cpf.length() != 11 && cpf.length() != 14) {
            throw new IllegalArgumentException("CPF inválido.");
        }

        if (phone != null && !phone.trim().isEmpty() && phone.length() < 8) {
            throw new IllegalArgumentException("Telefone inválido.");
        }

        if (address == null || address.trim().isEmpty()) {
            throw new IllegalArgumentException("Endereço é obrigatório.");
        }

        CommercialUser commercialUser = new CommercialUser
                (name, age, address, phone, cpf, email, hashPassword);

        userDao.registerUser(commercialUser);
    }

    public List<String> getCommercialUsersName()
    {
        return userDao.getCommercialUsersName();
    }
    public CommercialUser getById(int id)
    {
        return userDao.getById(id);
    }
    public List<CommercialUser> getByName(String name)
    {
        return userDao.getByName(name);
    }
    public void deleteUser(int id)
    {
        userDao.deleteUser(id);
    }
    public void updateUser(CommercialUser commercialUser)
    {
        userDao.updateUser(commercialUser);
    }
}