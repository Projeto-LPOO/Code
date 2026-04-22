package com.aura.meeting.model;

public class Location {

    private String city;
    private String neighborhood;
    private String street;
    private int houseNumber;
    private String referencePoint;


    public String getCity() {return city;}
    public void setCity(String city) {this.city = city;}

    public String getNeighborhood() {return neighborhood;}
    public void setNeighborhood(String neighborhood) {this.neighborhood = neighborhood;}

    public String getStreet() {return street;}
    public void setStreet(String street) {this.street = street;}

    public int getHouseNumber() {return houseNumber;}
    public void setHouseNumber(int houseNumber) {this.houseNumber = houseNumber;}

    public String getReferencePoint() {return referencePoint;}
    public void setReferencePoint(String referencePoint) {this.referencePoint = referencePoint;}
}
