package com.aura.financial.models;

import com.aura.shared.BaseEntity;
import com.aura.user.models.CommercialUser;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Credits extends BaseEntity {
    private CommercialUser user;
    private BigDecimal balance;
    private BigDecimal totalEarned;
    private BigDecimal totalSpent;
    private List<Transaction> transactions;

    public Credits() {}

    public Credits(CommercialUser user, BigDecimal balance, BigDecimal total_earned,
                   BigDecimal total_spent) {
        this.user = user;
        this.balance = balance;
        this.totalEarned = total_earned;
        this.totalSpent = total_spent;
        this.transactions = new ArrayList<>();
    }

    public CommercialUser getUser() { return user; }
    public void setUser(CommercialUser user) { this.user = user; }

    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }

    public BigDecimal getTotalEarned() { return totalEarned; }
    public void setTotalEarned(BigDecimal totalEarned) { this.totalEarned = totalEarned; }

    public BigDecimal getTotalSpent() { return totalSpent; }
    public void setTotalSpent(BigDecimal totalSpent) { this.totalSpent = totalSpent; }

    public List<Transaction> getTransactions() { return transactions; }
    public void setTransactions(Transaction transactions) { this.transactions.add(transactions);}
}