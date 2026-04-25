package com.aura.user.models;

import com.aura.interest.model.Interest;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CommercialUser extends User{

    protected int creditos;
    protected List<Interest> interests;

    public CommercialUser(){
        this.interests = new ArrayList<>();
    }
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
        this.interests = new ArrayList<>();
    }
    public void setInterests(Interest interest)
    {
        this.interests.add(interest);
    }
    public List<Interest> getInterests()
    {
        return this.interests;
    }


}
