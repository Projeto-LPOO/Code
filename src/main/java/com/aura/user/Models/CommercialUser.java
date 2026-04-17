package com.aura.user.Models;

import java.sql.Timestamp;
import java.time.LocalDate;

public class CommercialUser extends User{

    protected int creditos;

    public CommercialUser(){}
    public CommercialUser(String name, int age, String address, String phone,
                            String cpf, String email, String hashPassword)
    {
        this.name = name;
        this.age = age;
        this.address = address;
        this.phone = phone;
        this.cpf = cpf;
        this.email = email;
        this.hashPassword = hashPassword;
        this.creditos = 60;
        this.updatedAt = Timestamp.valueOf(java.time.LocalDateTime.now());
    }


}
