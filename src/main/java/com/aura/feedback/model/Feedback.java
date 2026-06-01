package com.aura.feedback .model;

import java.time.LocalDateTime;
import com.aura.shared.BaseEntity;

public class Feedback extends BaseEntity {
    private int meetingId;
    private int fromUserId;
	private String fromUserName;
	private int toUserId;
    private int rating; 
    private String comment;
    private LocalDateTime date;
    
    public Feedback(int meetingId, int fromUserId, int toUserId, int rating, String comment) {
    	this.meetingId = meetingId;
    	this.fromUserId = fromUserId;
    	this.toUserId = toUserId;
    	this.rating = rating;
    	this.comment = comment;
    	
    }
    public Feedback(){}
	public int getMeetingId() {
		return meetingId;
	}
	public void setMeetingId(int meetingId) {
		this.meetingId = meetingId;
	}
	public int getFromUserId() {
		return fromUserId;
	}
	public void setFromUserId(int fromUserId) {
		this.fromUserId = fromUserId;
	}
	public int getToUserId() {
		return toUserId;
	}
	public void setToUserId(int toUserId) {
		this.toUserId = toUserId;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public LocalDateTime getDate() {
		return date;
	}
	public void setDate(LocalDateTime date) {
		this.date = date;
	}

	public String getFromUserName() {
		return fromUserName;
	}

	public void setFromUserName(String fromUserName) {
		this.fromUserName = fromUserName;
	}
    
    
}