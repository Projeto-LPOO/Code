package com.aura.financial.models;

public class GateWayResponse {
    private long id;
    private boolean result;
    private String msg;

    public GateWayResponse(){}
    public long getId()
    {
        return id;
    }
    public void setId(long id)
    {
        this.id = id;
    }
    public boolean getResult()
    {
        return result;
    }
    public void setResult(boolean result)
    {
        this.result = result;
    }
    public String getMsg()
    {
        return msg;
    }
    public void setMsg(String msg)
    {
        this.msg = msg;
    }
}
