package com.aura.dbConfig;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {

    public static void main(String[] args) {
        System.out.println("Testando conexão com o banco...");

        try (Connection conn = dbFactory.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Conexão estabelecida com sucesso!");
                System.out.println("Banco: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("Versão: " + conn.getMetaData().getDatabaseProductVersion());
            }
        } catch (SQLException e) {
            System.out.println(" Erro ao conectar: " + e.getMessage());
        }
    }
}
