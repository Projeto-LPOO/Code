package com.aura.financial.models;

import com.aura.financial.models.enums.TransactionType;
import java.math.BigDecimal;

public class BuyTransaction extends Transaction {

    public BuyTransaction() {}

    public BuyTransaction(BankAccount account, BigDecimal amount) {
        super(account, amount, TransactionType.BUY);
    }
    @Override
    public void process(Credits credits, int amountCredits) {
        credits.buy(amountCredits);
    }
}