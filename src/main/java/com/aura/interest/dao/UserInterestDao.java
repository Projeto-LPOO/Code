package com.aura.interest.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.interest.model.Interest;
import com.aura.interest.model.InterestType;
import com.aura.user.models.CommercialUser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

public class UserInterestDao {

    public void registerUserLearn(int idUSer, List<Integer> idsInterest, InterestType interestType)
    {
        String sql = "INSERT INTO user_interests(user_id, interest_id, interest_type) VALUES (?, ?, ?::interest_type_enum)";
        try (Connection conn = dbFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql))
        {

            conn.setAutoCommit(false);

            for (Integer id : idsInterest) {
                stmt.setInt(1, idUSer);
                stmt.setInt(2, id);
                stmt.setString(3, interestType.name());
                stmt.addBatch();
            }

            stmt.executeBatch();
            conn.commit();

        } catch (Exception e) {
            throw new RuntimeException(e);}
    }
}
