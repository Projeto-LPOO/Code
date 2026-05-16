package com.aura.financial.models;

import java.util.Random;
import java.util.UUID;

public class GateWay {

    private static Random random = new Random();

    public GateWayResponse validateTransaction(Transaction transaction) throws InterruptedException {
        int randomNumber =  random.nextInt(100);
        Thread.sleep(1000);
        long longUnique = UUID.randomUUID().getMostSignificantBits() & Long.MAX_VALUE;

        GateWayResponse response = new GateWayResponse();
        response.setId(longUnique);


        if(randomNumber < 0.20)
        {
            response.setResult(false);
            response.setMsg("Transação negada");
        }
        else {
            response.setResult(true);
            response.setMsg("Transação aceita");
        }
        return response;
    }


}
