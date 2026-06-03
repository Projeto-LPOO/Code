package com.aura.meeting.model;

import com.aura.shared.BaseEntity;
import com.aura.user.models.CommercialUser;

public class ReportEvidence extends BaseEntity {
    private MeetingReport report;
    private CommercialUser user;
    private String description;
    private String imagePath;
    private EvidenceAccepted accepted;

    public MeetingReport getReport() {
        return report;
    }

    public void setReport(MeetingReport report) {
        this.report = report;
    }

    public CommercialUser getUser() {
        return user;
    }

    public void setUser(CommercialUser user) {
        this.user = user;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImagePath() {return imagePath;}

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public void setAccepted(EvidenceAccepted accepted)
    {
        this.accepted = accepted;
    }
    public EvidenceAccepted getAccepted()
    {
        return accepted;
    }
}

