package com.aura.profile.models;

import com.aura.shared.BaseEntity;

public class Profile extends BaseEntity {

    private int userId;

    private String bio;

    private String city;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }
}