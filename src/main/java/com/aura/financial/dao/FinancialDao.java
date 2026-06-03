package com.aura.financial.dao;

import com.aura.dbConfig.dbFactory;
import com.aura.financial.models.BankAccount;
import com.aura.financial.models.CreditPackage;
import com.aura.financial.models.Credits;
import com.aura.financial.models.Transaction;
import com.aura.financial.models.enums.TransactionType;
import com.aura.user.models.CommercialUser;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FinancialDao {

    public BankAccount registerUserAccount(BankAccount account)
    {
        String sql = "INSERT INTO bank_accounts (user_id, account_number, bank_name, ispb, pix_key, agency, holder_name, active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, account.getUser().getId());
            stmt.setString(2, account.getAccountNumber());
            stmt.setString(3, account.getBankName());
            stmt.setString(4, account.getIsbp());
            stmt.setString(5, account.getPixKey());
            stmt.setString(6, account.getAgency());
            stmt.setString(7, account.getHolderName());
            stmt.setBoolean(8, account.isActive());

            ResultSet rs = stmt.executeQuery();

            if(rs.next())
            {
                account.setId(rs.getInt("id"));
            }

            return account;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void registerTransaction(Transaction transaction)
    {
        String sql = "INSERT INTO transactions (bank_account_id, amount, type, status, external_id) " +
                "VALUES (?, ?, ?::transaction_type, ?::transaction_status, ?)";

        try(Connection conn = dbFactory.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql))
        {
            stmt.setInt(1, transaction.getAccount().getId());
            stmt.setBigDecimal(2, transaction.getAmount());
            stmt.setString(3, transaction.getType().name());
            stmt.setString(4, transaction.getStatus().name());
            stmt.setLong(5, transaction.getExternalId());

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void updateCredits(Credits credits)
    {
        String sql = """
        UPDATE credits
        SET balance = ?,
            total_earned = ?,
            total_spent = ?,
            updated_at = NOW()
        WHERE user_id = ?
    """;

        try (Connection connection = dbFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setBigDecimal(1, credits.getBalance());
            stmt.setBigDecimal(2, credits.getTotalEarned());
            stmt.setBigDecimal(3, credits.getTotalSpent());
            stmt.setInt(4, credits.getUser().getId());

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Credits findById(int iduser)
    {
        String sql = "SELECT * FROM credits where user_id = ?";
        Credits credits = new Credits();

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, iduser);
            ResultSet rs = stmt.executeQuery();
            if(rs.next()){

                credits.setId(rs.getInt("id"));
                credits.setBalance(rs.getBigDecimal("balance") != null
                        ? rs.getBigDecimal("balance")
                        : BigDecimal.ZERO);

                credits.setTotalEarned(rs.getBigDecimal("total_earned") != null
                        ? rs.getBigDecimal("total_earned")
                        : BigDecimal.ZERO);

                credits.setTotalSpent(rs.getBigDecimal("total_spent") != null
                        ? rs.getBigDecimal("total_spent")
                        : BigDecimal.ZERO);

                CommercialUser user = new CommercialUser();

                user.setId(iduser);

                credits.setUser(user);
            }
            return credits;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public BankAccount findAccountUser(int id)
    {
        BankAccount account = null;
        String sql = "SELECT * FROM bank_accounts WHERE user_id = ?";
        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if(rs.next())
            {
                account = new BankAccount();
                account.setId(rs.getInt("id"));
                account.setBankName(rs.getString("bank_name"));
                account.setIsbp(rs.getString("ispb"));
                account.setAgency(rs.getString("agency"));
                account.setAccountNumber(rs.getString("account_number"));
                account.setPixKey(rs.getString("pix_key"));
                account.setHolderName(rs.getString("holder_name"));
            }
            return account;
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public CreditPackage findCreditPackage(int id)
    {
        CreditPackage creditPackage = null;
        String sql = "SELECT * FROM credits_package WHERE id = ?";
        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql))
        {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if(rs.next())
            {
                creditPackage = new CreditPackage();
                creditPackage.setId(rs.getInt("id"));
                creditPackage.setName(rs.getString("name"));
                creditPackage.setCredits(rs.getInt("credits"));
                creditPackage.setPrice(rs.getBigDecimal("price"));
            }
            return creditPackage;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<CreditPackage> findAll()
    {
        List<CreditPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM credits_package";

        try(Connection connection = dbFactory.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery())
        {
            while(rs.next())
            {
                CreditPackage cp = new CreditPackage();

                cp.setId(rs.getInt("id"));
                cp.setName(rs.getString("name"));
                cp.setCredits(rs.getInt("credits"));
                cp.setPrice(rs.getBigDecimal("price"));

                list.add(cp);
            }

            return list;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    public void applyMeetingCredits(int learnerId, int teacherId, int amount, boolean isDone) {
        try (Connection conn = dbFactory.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Credits learnerCredits = findByIdForUpdate(conn, learnerId);
                Credits teacherCredits = findByIdForUpdate(conn, teacherId);

                BigDecimal amountBD = BigDecimal.valueOf(amount);
                if (isDone) {
                    if (learnerCredits.getBalance().compareTo(amountBD) < 0) {
                        throw new IllegalStateException(
                                "Saldo insuficiente. Você precisa de " + amount +
                                        " CS mas possui apenas " + learnerCredits.getBalance().intValue() + " CS."
                        );
                    }
                    // Debitar aluno
                    learnerCredits.setBalance(learnerCredits.getBalance().subtract(amountBD));
                    learnerCredits.setTotalSpent(learnerCredits.getTotalSpent().add(amountBD));
                    // Creditar professor
                    teacherCredits.setBalance(teacherCredits.getBalance().add(amountBD));
                    teacherCredits.setTotalEarned(teacherCredits.getTotalEarned().add(amountBD));
                } else {
                    if (teacherCredits.getBalance().compareTo(amountBD) < 0) {
                        throw new IllegalStateException(
                                "Saldo insuficiente do professor para estorno."
                        );
                    }
                    teacherCredits.setBalance(teacherCredits.getBalance().subtract(amountBD));
                    teacherCredits.setTotalSpent(teacherCredits.getTotalSpent().add(amountBD)); // corrigir: totalEarned deve diminuir no estorno
                    learnerCredits.setBalance(learnerCredits.getBalance().add(amountBD));
                    teacherCredits.setTotalEarned(teacherCredits.getTotalEarned().subtract(amountBD));
                    learnerCredits.setTotalSpent(learnerCredits.getTotalSpent().subtract(amountBD));
                }

                updateCreditsInTransaction(conn, learnerCredits);
                updateCreditsInTransaction(conn, teacherCredits);
                conn.commit();

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (IllegalStateException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private Credits findByIdForUpdate(Connection conn, int userId) throws Exception {
        String sql = "SELECT * FROM credits WHERE user_id = ? FOR UPDATE";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next())
                throw new IllegalStateException("Credits record not found for user " + userId);

            Credits credits = new Credits();
            credits.setId(rs.getInt("id"));
            credits.setBalance(rs.getBigDecimal("balance") != null ? rs.getBigDecimal("balance") : BigDecimal.ZERO);
            credits.setTotalEarned(rs.getBigDecimal("total_earned") != null ? rs.getBigDecimal("total_earned") : BigDecimal.ZERO);
            credits.setTotalSpent(rs.getBigDecimal("total_spent") != null ? rs.getBigDecimal("total_spent") : BigDecimal.ZERO);
            CommercialUser user = new CommercialUser();
            user.setId(userId);
            credits.setUser(user);
            return credits;
        }
    }

    private void updateCreditsInTransaction(Connection conn, Credits credits) throws Exception {
        String sql = """
        UPDATE credits
        SET balance = ?,
            total_earned = ?,
            total_spent = ?,
            updated_at = NOW()
        WHERE user_id = ?
    """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBigDecimal(1, credits.getBalance());
            stmt.setBigDecimal(2, credits.getTotalEarned());
            stmt.setBigDecimal(3, credits.getTotalSpent());
            stmt.setInt(4, credits.getUser().getId());
            stmt.executeUpdate();
        }
    }

}
