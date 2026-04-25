package com.aura.interest.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.interest.model.Interest;
import com.aura.interest.model.InterestType;
import com.aura.user.models.CommercialUser;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class UserInterestDao {

    public void registerUserInterest(Interest interest, CommercialUser commercialUser, InterestType interestType)
    {
        String sql = "INSERT INTO user_interests(user_id, interest_id, interest_type) VALUES (?, ?, ?::interest_type_enum)";
        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql))
        {
            stmt.setInt(1, commercialUser.getId());
            stmt.setInt(2, interest.getId());
            stmt.setString(3, interestType.name());

            stmt.executeUpdate();
            System.out.println(" Interesse do usuario salvo com sucesso!");

        } catch (Exception e) {
            throw new RuntimeException(e);}
    }
}
