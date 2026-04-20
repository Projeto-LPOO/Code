package com.aura.interest;

import com.aura.category.Category;

public class InterestModel {
    private int idInterest;
    private String name;
    private String description;
    private InterestType type;
    private Category category;

    public InterestModel() {
    }
    // Construtor sem o ID
    public InterestModel(String name, String description, InterestType type, Category category) {
        this.name = name;
        this.description = description;
        this.type = type;
        this.category = category;
    }

  // Construtor com o ID
    public InterestModel(int id, String name, String description, InterestType type, Category category) {
        this.idInterest = id;
        this.name = name;
        this.description = description;
        this.type = type;
        this.category = category;
    }

    public int getIdInterest() {
        return idInterest;
    }

    public void setIdInterest(int idInterest) {
        this.idInterest = idInterest;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public InterestType getType() {
        return type;
    }

    public void setType(InterestType type) {
        this.type = type;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

}
