package availability;


import java.time.DayOfWeek;
import java.time.LocalTime;

import com.aura.shared.BaseEntity;
import com.aura.user.Models.CommercialUser;



public class Availability extends BaseEntity{
	protected int idAvailability;
	protected CommercialUser user;
	protected DayOfWeek dayWeek;
	protected LocalTime hourStart;
	protected LocalTime hourEnd;
	protected boolean Active;
	
	public Availability(CommercialUser user, DayOfWeek dayWeek, LocalTime hourStart, LocalTime hourEnd) {
		this.user = user;
        this.dayWeek = dayWeek;
        this.hourStart = hourStart;
        this.hourEnd = hourEnd;
	}
	
	public Availability() {
		
	}
	public boolean isActive() {
	    return Active;
	}
	public void setActive(boolean Available) {
	    this.Active = Available;
	}

	public int getIdAvailability() {
		return idAvailability;
	}

	public void setIdAvailability(int idAvailability) {
		this.idAvailability = idAvailability;
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
