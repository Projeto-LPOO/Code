package com.aura.availability;


import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.List;

import com.aura.dbConfig.dbFactory;
import com.aura.user.Models.CommercialUser;

import java.sql.Connection;

public class AvailabilityDao {
	public void registerAvailability(Availability myAvailability) {
		String sql = "INSERT INTO availability (id_user_commercial, day_of_week, hour_start, hour_end) VALUES (?, ?::day_of_week, ?, ?)";
		
		 try(Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)){
			 
		            stmt.setInt(1, myAvailability.getUser().getId());
		            stmt.setString(2, translateDayToDb(myAvailability.getDayWeek()));
		            stmt.setTime(3, java.sql.Time.valueOf(myAvailability.getHourStart()));
		            stmt.setTime(4, java.sql.Time.valueOf(myAvailability.getHourEnd()));
		            stmt.executeUpdate();

		        }catch (Exception e) {
		        	throw new RuntimeException("Erro ao inserir: " + e.getMessage(), e);
		 }
	}
	
	
	public void removeAvailability(int idAvailability) {
		String sql = "DELETE FROM availability WHERE id = ?";
		
		try(Connection connection = dbFactory.getConnection();
	        PreparedStatement stmt = connection.prepareStatement(sql)){
			
	            stmt.setInt(1, idAvailability);

	            int rowsAffects = stmt.executeUpdate();

	            if (rowsAffects > 0){
	                System.out.println("Disponibilidade deletada com sucesso");
	            }
	            else {
	                System.out.println("nao existe disponibilidade com esse id");
	            }

	        } catch (Exception e) {
	            throw new RuntimeException("Erro ao deletar: " + e.getMessage());
	        }
	}
	
	public void updateAvailability(Availability upAvailability) {
		String sql = "UPDATE availability SET day_of_week = ?::day_of_week, hour_start = ?, hour_end = ? WHERE id = ? AND id_user_commercial = ?";
		
		try(Connection connection = dbFactory.getConnection();
			PreparedStatement stmt = connection.prepareStatement(sql)){
				
			stmt.setString(1, translateDayToDb(upAvailability.getDayWeek()));
				stmt.setTime(2, Time.valueOf(upAvailability.getHourStart()));
				stmt.setTime(3, Time.valueOf(upAvailability.getHourEnd()));
				stmt.setInt(4, upAvailability.getId());
				stmt.setInt(5, upAvailability.getUser().getId());
				
				stmt.executeUpdate();
				
			} catch (Exception e) {
				throw new RuntimeException("Erro ao atualizar: " + e.getMessage(), e);
			}
	}
	
	public Availability getById(int idAvailability) {
		String sql = "SELECT * FROM availability WHERE id = ?";
		Availability dispo= null;
		
		try(Connection connection = dbFactory.getConnection();
	        PreparedStatement stmt = connection.prepareStatement(sql);){
			
			stmt.setInt(1,  idAvailability);
			
			ResultSet rs = stmt.executeQuery();
			
			if (rs.next()) {
				dispo = new Availability();
				dispo.setId(idAvailability);
				CommercialUser user = new CommercialUser();
		        user.setId(rs.getInt("id_user_commercial"));
		        dispo.setUser(user);
				dispo.setDayWeek(translateDayFromDb(rs.getString("day_of_week")));
				dispo.setHourStart(rs.getTime("hour_start").toLocalTime());
				dispo.setHourEnd(rs.getTime("hour_end").toLocalTime());
				dispo.setActive(rs.getBoolean("active"));
				
				}
			}catch(Exception e) {
				throw new RuntimeException("Erro ao buscar por ID: " + e.getMessage(), e);
			}
			return dispo;
	}
	
	public List<Availability> findAllAvailability(int idUserCommercial){
		String sql = "SELECT * FROM availability WHERE id_user_commercial = ?";
		List<Availability> lista = new ArrayList<>();
		
		try(Connection connection = dbFactory.getConnection();
			PreparedStatement stmt = connection.prepareStatement(sql)){
			
			stmt.setInt(1, idUserCommercial);
			ResultSet rs = stmt.executeQuery();
			

			while (rs.next()) {
				Availability dispo = new Availability();
				dispo.setId(rs.getInt("id"));
				CommercialUser user = new CommercialUser();
		        user.setId(rs.getInt("id_user_commercial"));
		        dispo.setUser(user);
				dispo.setDayWeek(translateDayFromDb(rs.getString("day_of_week")));
				dispo.setHourStart(rs.getTime("hour_start").toLocalTime());
				dispo.setHourEnd(rs.getTime("hour_end").toLocalTime());
				dispo.setActive(rs.getBoolean("active"));
				
				lista.add(dispo);
			}
		} catch(Exception e) {
			throw new RuntimeException("Erro ao listar disponibilidades: " + e.getMessage(), e);
		}
		return lista;
	}
	
	public void changeStatus(int idAvailability, boolean newStatus) {
		String sql = "UPDATE availability SET active = ? WHERE id = ?";
	    
	    try(Connection connection = dbFactory.getConnection();
	        PreparedStatement stmt = connection.prepareStatement(sql)) {
	        
	        stmt.setBoolean(1, newStatus); 
	        stmt.setInt(2, idAvailability);
	        
	        int linhasAfetadas = stmt.executeUpdate();
	        
	        if(linhasAfetadas == 0) {
	            System.out.println("Aviso: O banco não achou nenhuma disponibilidade com o ID " + idAvailability);
	        }
	        
	    } catch (Exception e) {
	        throw new RuntimeException("Erro ao mudar status no banco de dados: " + e.getMessage(), e);
	    }
	}
	
	private String translateDayToDb(DayOfWeek day) {
	    switch (day) {
	        case MONDAY: return "SEGUNDA";
	        case TUESDAY: return "TERÇA";
	        case WEDNESDAY: return "QUARTA";
	        case THURSDAY: return "QUINTA";
	        case FRIDAY: return "SEXTA";
	        case SATURDAY: return "SABADO";
	        case SUNDAY: return "DOMINGO";
	        default: return "SEGUNDA";
	    }
	}
	
	private DayOfWeek translateDayFromDb(String dia) {
	    switch (dia.toUpperCase()) {
	        case "SEGUNDA": return DayOfWeek.MONDAY;
	        case "TERÇA": return DayOfWeek.TUESDAY;
	        case "QUARTA": return DayOfWeek.WEDNESDAY;
	        case "QUINTA": return DayOfWeek.THURSDAY;
	        case "SEXTA": return DayOfWeek.FRIDAY;
	        case "SABADO": return DayOfWeek.SATURDAY;
	        case "DOMINGO": return DayOfWeek.SUNDAY;
	        default: return DayOfWeek.MONDAY;
	    }
	}
}
