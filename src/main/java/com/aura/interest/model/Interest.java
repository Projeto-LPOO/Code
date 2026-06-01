package com.aura.interest.model;

import com.aura.category.Category;

public class Interest {
    private int idInterest;
    private String name;
    private String description;
    private Category category;
    public Interest() {
    }
    // Construtor sem o ID
    public Interest(String name, String description, Category category) {
        this.name = name;
        this.description = description;
        this.category = category;
    }

  // Construtor com o ID
    public Interest(int id, String name, String description, Category category) {
        this.idInterest = id;
        this.name = name;
        this.description = description;
        this.category = category;
    }



    public int getId() {
        return idInterest;
    }

    public void setId(int idInterest) {
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

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

}
