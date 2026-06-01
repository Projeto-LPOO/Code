package com.aura.financial.models;

import com.aura.financial.models.enums.TransactionStatus;
import com.aura.financial.models.enums.TransactionType;
import com.aura.shared.BaseEntity;

import java.math.BigDecimal;

public abstract class Transaction extends BaseEntity {
    private BankAccount account;
    private BigDecimal amount;
    private String description;
    private TransactionType type;
    private TransactionStatus status;
    private long externalId;

    public Transaction() {}

    public Transaction(BankAccount account, BigDecimal amount, TransactionType type) {
        this.account = account;
        this.amount = amount;
        this.type = type;
        this.status = TransactionStatus.PENDING;
    }

    public abstract void process(Credits credits, int amountCredits);

    public BankAccount getAccount() {
        return account;
    }

    public void setAccount(BankAccount account) {
        this.account = account;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public TransactionType getType() {
        return type;
    }

    public void setType(TransactionType type) {
        this.type = type;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public void setStatus(TransactionStatus status) {
        this.status = status;
    }

    public long getExternalId() {
        return externalId;
    }

    public void setExternalId(long externalId) {
        this.externalId = externalId;
    }
}