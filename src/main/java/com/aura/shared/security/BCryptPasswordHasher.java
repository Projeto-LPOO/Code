package com.aura.shared.security;

import org.mindrot.jbcrypt.BCrypt;

public class BCryptPasswordHasher implements PasswordHasher{

    private static final int COST = 10;

    @Override
    public String hash(String password)
    {
        if(password == null || password.equals("null"))
        {
            throw new IllegalArgumentException("senha não pode ser nula");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(COST));
    }

    @Override
    public boolean verify(String password, String hashPassword) {
        if(password == null || hashPassword == null)
        {
            return false;
        }
        return BCrypt.checkpw(password, hashPassword);
    }
}
