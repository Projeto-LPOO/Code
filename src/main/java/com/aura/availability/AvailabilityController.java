	package com.aura.availability;

	import java.time.DayOfWeek;
	import java.time.LocalTime;
	import java.time.format.DateTimeFormatter;
	import java.time.format.DateTimeParseException;
	import java.util.List;

import com.aura.user.models.CommercialUser;

	
	public class AvailabilityController {
		
		private AvailabilityDao AvailabilityDao;
		
		public AvailabilityController() {
			AvailabilityDao = new AvailabilityDao();
		}
		
		public void registerAvailability(int idUserCommercial, DayOfWeek dayWeek, String textStart, String textEnd) {
			LocalTime hourStart = formattedHour(textStart);
			LocalTime hourEnd = formattedHour(textEnd);
			
			if(hourStart == null) {
				throw new IllegalArgumentException("Hora de inicio inválida.");
			}
			if(hourEnd == null){
				throw new IllegalArgumentException("Hora de fim inválido.");
			}
			
			if(hourStart.isAfter(hourEnd) || hourStart.equals(hourEnd)) {
		        throw new IllegalArgumentException("Erro A hora nao pode ser menor ou igual hora do termino");
		    }
			List<Availability> existingSchedules = findAllAvailability(idUserCommercial);
			for(Availability existing : existingSchedules) {
				if(existing.getDayWeek().equals(dayWeek)) {
					LocalTime exStart = existing.getHourStart();
					LocalTime exEnd = existing.getHourEnd();
					if(hourStart.isBefore(exEnd) && hourEnd.isAfter(exStart)) {
						throw new IllegalArgumentException("Conflito de horário! Esse Usuario já tem um compromisso das " 
                                + exStart + " às " + exEnd + " na " + dayWeek);
					}
				}
			}
			
			CommercialUser user = new CommercialUser();
		    user.setId(idUserCommercial);

			Availability myDisponibility = new Availability(user, dayWeek, hourStart, hourEnd);
			AvailabilityDao.registerAvailability(myDisponibility);
			System.out.println("Horario salvo");
		}
		
		private LocalTime formattedHour(String hour) {
			try {
				DateTimeFormatter format = DateTimeFormatter.ofPattern("HH:mm");
				return LocalTime.parse(hour, format);
			} catch (DateTimeParseException e) {
				System.out.println("ERRO: formato inválido na string: " + hour);
				return null;
			}
		}
		
		public void RemoveAvailability(int idAvailability) {
			try {
		        AvailabilityDao.removeAvailability(idAvailability);
		    } catch (Exception e) {
		        System.out.println("Erro no Controller ao tentar remover disponibilidade: " + e.getMessage());
		    }	
		}
		
		public void UpdateAvailability(int idAvailability, int idUserCommercial, DayOfWeek dayWeek, String textStart, String textEnd) {
			LocalTime hourStart = formattedHour(textStart);
			LocalTime hourEnd = formattedHour(textEnd);
			
			if(hourStart == null) {
				throw new IllegalArgumentException("Hora de inicio inválida.");
			}
			if(hourEnd == null){
				throw new IllegalArgumentException("Hora de fim inválido.");
			}
			
			if(hourStart.isAfter(hourEnd) || hourStart.equals(hourEnd)) {
		        throw new IllegalArgumentException("Erro A hora nao pode ser menor ou igual hora do termino");
		    }
			List<Availability> existingSchedules = findAllAvailability(idUserCommercial);
			for(Availability existing : existingSchedules) {
				if (existing.getId() != idAvailability) {
					if(existing.getDayWeek().equals(dayWeek)) {
						LocalTime exStart = existing.getHourStart();
						LocalTime exEnd = existing.getHourEnd();
						if(hourStart.isBefore(exEnd) && hourEnd.isAfter(exStart)) {
							throw new IllegalArgumentException("Conflito de horário! Esse Usuario já tem um compromisso das " 
	                                + exStart + " às " + exEnd + " na " + dayWeek);
						}
					}
				}
			}
			CommercialUser user = new CommercialUser();
	        user.setId(idUserCommercial);
	        
			Availability upAvailability = new Availability(user, dayWeek, hourStart, hourEnd);
			upAvailability.setId(idAvailability);
			AvailabilityDao.updateAvailability(upAvailability);
		        
		    
		}
		
		public Availability getById(int idDisponibility) {
			return AvailabilityDao.getById(idDisponibility);
		}
		
		public List<Availability> findAllAvailability(int idUserCommercial){
			return AvailabilityDao.findAllAvailability(idUserCommercial);
		}

		public void ChangeStatus(int idAvailability, boolean newStatus) {
		    try {
		    	AvailabilityDao.changeStatus(idAvailability, newStatus);
		    } catch (Exception e) {
		        System.out.println("Erro no Controller ao tentar mudar o status: " + e.getMessage());
		    }
			
		}
	}
