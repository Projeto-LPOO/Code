package com.aura.meeting.model;

import com.aura.shared.BaseEntity;
import com.aura.user.models.CommercialUser;


public class MeetingReport extends BaseEntity {
    private Meeting meeting;
    private CommercialUser fromUser;
    private String description;
    private ReportCategory category;
    private Boolean status;

    public Meeting getMeetingReport()
    {
        return this.meeting;
    }
    public String getDescription()
    {
        return this.description;
    }
    public void setMeetingReport(Meeting meeting)
    {
        this.meeting = meeting;
    }
    public  void setDescription(String description)
    {
        this.description = description;
    }
    public CommercialUser getFromUser() {
        return fromUser;
    }

    public void setFromUser(CommercialUser fromUser) {
        this.fromUser = fromUser;
    }
    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }
    public void setCategory(ReportCategory category)
    {
        this.category = category;
    }
    public ReportCategory getCategory()
    {
        return category;
    }
}

