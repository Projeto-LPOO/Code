package com.aura.meeting.model;

import com.aura.shared.BaseEntity;
import com.aura.user.models.CommercialUser;


public class MeetingReport extends BaseEntity {
    private Meeting meeting;
    private CommercialUser fromUser;
    private String reason;
    private ReportStatus status;

    public Meeting getMeetingReport()
    {
        return this.meeting;
    }
    public String getReason()
    {
        return this.reason;
    }
    public void setMeetingReport(Meeting meeting)
    {
        this.meeting = meeting;
    }
    public  void setReason(String reason)
    {
        this.reason = reason;
    }
    public CommercialUser getFromUser() {
        return fromUser;
    }

    public void setFromUser(CommercialUser fromUser) {
        this.fromUser = fromUser;
    }
    public ReportStatus getStatus() {
        return status;
    }

    public void setStatus(ReportStatus status) {
        this.status = status;
    }
}

