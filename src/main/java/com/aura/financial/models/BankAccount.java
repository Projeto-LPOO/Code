package com.aura.financial.models;

import com.aura.shared.BaseEntity;
import com.aura.user.models.CommercialUser;

public class BankAccount extends BaseEntity {
    private CommercialUser user;
    private String holderName;
    private String isbp;
    private String pixKey;
    private String accountNumber;
    private String bankName;
    private String agency;
    private boolean active;

    public BankAccount() {}

    public BankAccount(CommercialUser user, String holderName, String isbp, String pixKey,
                       String accountNumber, String bankName, String agency) {
        this.user = user;
        this.holderName = holderName;
        this.isbp = isbp;
        this.pixKey = pixKey;
        this.accountNumber = accountNumber;
        this.bankName = bankName;
        this.agency = agency;
        this.active = true;
    }

    public CommercialUser getUser() { return user; }
    public void setUser(CommercialUser user) { this.user = user; }

    public String getHolderName() { return holderName; }
    public void setHolderName(String holderName) { this.holderName = holderName; }

    public String getIsbp() { return isbp; }
    public void setIsbp(String isbp) { this.isbp = isbp; }

    public String getPixKey() { return pixKey; }
    public void setPixKey(String pixKey) { this.pixKey = pixKey; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getAgency() { return agency; }
    public void setAgency(String agency) { this.agency = agency; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}