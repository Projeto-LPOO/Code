package com.aura.meeting.model;

public class ReportingMetrics {
    private int totalReports;
    private int totalEvidences;
    private int pendentes;
    private int resolvidos;
    private int recusados;


    public int getTotalReports() {
        return totalReports;
    }

    public void setTotalReports(int total) {
        this.totalReports = total;
    }
    public int getTotalEvidences() {
        return totalEvidences;
    }

    public void setTotalEvidences(int total) {
        this.totalEvidences = total;
    }

    public int getPendentes() {
        return pendentes;
    }

    public void setPendentes(int pendentes) {
        this.pendentes = pendentes;
    }

    public int getResolvidos() {
        return resolvidos;
    }

    public void setResolvidos(int resolvidos) {
        this.resolvidos = resolvidos;
    }
    public int getRecusados() {
        return recusados;
    }

    public void setRecusados(int recusados) {
        this.recusados = recusados;
    }
}
