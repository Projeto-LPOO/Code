package com.aura.meeting.model;

public class FaceToFaceMeeting extends Meeting {

    private String instructions;
    private Location location;


    public String getInstructions() {return instructions;}
    public void setInstructions(String instructions) {this.instructions = instructions;}

    public Location getLocation() {return location;}
    public void setLocation(Location location) {this.location = location;}

    @Override
    public String getMeetingType() { return "PRESENCIAL"; }

}
