package com.aura.financial.models;

import com.aura.shared.BaseEntity;

import java.math.BigDecimal;

public class CreditPackage extends BaseEntity {
    private String name;
    private int credits;
    private BigDecimal price;

    public CreditPackage(){}

    public String getName()
    {
        return name;
    }
    public void setName(String name)
    {
        this.name = name;
    }
    public int getCredits()
    {
        return credits;
    }
    public void setCredits(int credits)
    {
        this.credits = credits;
    }
    public BigDecimal getPrice()
    {
        return price;
    }
    public void setPrice(BigDecimal price)
    {
        this.price = price;
    }
}
