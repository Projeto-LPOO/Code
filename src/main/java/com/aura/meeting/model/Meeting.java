package com.aura.meeting.model;

import com.aura.category.Category;
import com.aura.shared.BaseEntity;
import com.aura.user.models.Learner;
import com.aura.user.models.Teacher;

import java.time.LocalDateTime;

public class Meeting extends BaseEntity {

    protected String description;
    protected Learner learner;
    protected Teacher teacher;
    protected Category category;
    protected LocalDateTime dayTime;
    protected String status;
    // Duração em minutos: 60 = 1h (60 CS), 90 = 1h30 (90 CS), 120 = 2h (120 CS)
    protected int durationMinutes;

    // getters e setters
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Learner getLearner() { return learner; }
    public void setLearner(Learner learner) { this.learner = learner; }

    public Teacher getTeacher() { return teacher; }
    public void setTeacher(Teacher teacher) { this.teacher = teacher; }

    public LocalDateTime getDayTime() { return dayTime; }
    public void setDayTime(LocalDateTime dayTime) { this.dayTime = dayTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }


     //retorna o custo em CS baseado na duração.
     //60 min = 60 CS, 90 min = 90 CS, 120 min = 120 CS.

    public int getCostInCredits() {
        return durationMinutes;
    }
}