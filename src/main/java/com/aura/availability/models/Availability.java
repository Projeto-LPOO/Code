package com.aura.availability.models;


import java.time.DayOfWeek;

import java.time.LocalTime;

import com.aura.shared.BaseEntity;
import com.aura.user.models.CommercialUser;

public class Availability extends BaseEntity{
	private CommercialUser user;
	private DayOfWeek dayWeek;
	private LocalTime hourStart;
	private LocalTime hourEnd;
	private boolean available = true;
	
	public Availability(CommercialUser user, DayOfWeek dayWeek, LocalTime hourStart, LocalTime hourEnd) {
		this.user = user;
        this.dayWeek = dayWeek;
        this.hourStart = hourStart;
        this.hourEnd = hourEnd;
	}
	
	public Availability() {
		
	}
	public boolean isAvailable() {
	    return available;
	}
	public void setAvailable(boolean Available) {
	    this.available = Available;
	}
	

	public CommercialUser getUser() {
		return user;
	}

	public void setUser(CommercialUser user) {
		this.user = user;
	}

	public DayOfWeek getDayWeek() {
		return dayWeek;
	}

	public void setDayWeek(DayOfWeek dayWeek) {
		this.dayWeek = dayWeek;
	}

	public LocalTime getHourStart() {
		return hourStart;
	}

	public void setHourStart(LocalTime hourStart) {
		this.hourStart = hourStart;
	}

	public LocalTime getHourEnd() {
		return hourEnd;
	}

	public void setHourEnd(LocalTime hourEnd) {
		this.hourEnd = hourEnd;
	}
	
	
}
