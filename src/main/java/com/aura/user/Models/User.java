package com.aura.user.Models;

import com.aura.shared.BaseEntity;

import java.time.LocalDate;

public abstract class User extends BaseEntity {
    protected String name;
    protected int age;
    protected String address;
    protected String phone;
    protected String cpf;
    protected String email;
    protected String hashPassword;
    protected LocalDate lastAccess;

    //getters e setters
    public String getName() {return name;}
    public void setName(String name) {this.name = name;}

    public int getAge() {return age;}
    public void setAge(int age) {this.age = age;}

    public String getAddress() {return address;}
    public void setAddress(String adress) {this.address = adress;}

    public String getPhone() {return phone;}
    public void setPhone(String phone) {this.phone = phone;}

    public String getCpf() {return cpf;}
    public void setCpf(String cpf) {this.cpf = cpf;}

    public String getEmail() {return email;}
    public void setEmail(String email) {this.email = email;}

    public String getHashPassword() {return hashPassword;}
    public void setHashPassword(String hashPassword) {this.hashPassword = hashPassword;}

    public LocalDate getLastAccess() {return lastAccess;}
    public void setLastAccess(LocalDate lastAccess) {this.lastAccess = lastAccess;}

    @Override
    public String toString() {
        return this.getName() +" - "+ this.getAddress() + " - " + this.getPhone();
    }
}
