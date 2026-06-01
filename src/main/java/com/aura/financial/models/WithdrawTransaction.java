package com.aura.financial.models;

import com.aura.financial.models.enums.TransactionType;
import java.math.BigDecimal;

public class WithdrawTransaction extends Transaction {

    public WithdrawTransaction() {}

    public WithdrawTransaction(BankAccount account, BigDecimal amount) {
        super(account, amount, TransactionType.WITHDRAW);
    }

    @Override
    public void process(Credits credits, int amountCredits) {
        credits.withdraw(amountCredits);
    }
}