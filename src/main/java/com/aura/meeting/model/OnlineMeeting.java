package com.aura.meeting.model;

public class OnlineMeeting extends Meeting{

    private String linkPlataform;

    public String getLinkPlataform() {return linkPlataform;}
    public void setLinkPlataform(String linkPlataform) {this.linkPlataform = linkPlataform;}

    @Override
    public String getMeetingType() { return "ONLINE"; }
    
}
