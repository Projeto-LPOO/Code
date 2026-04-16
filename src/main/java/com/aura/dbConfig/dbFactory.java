package com.aura.dbConfig;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class dbFactory {

    private static HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream input = dbFactory.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties");

            if (input == null) {
                throw new RuntimeException("Arquivo db.properties não encontrado!");
            }

            props.load(input);

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maxSize")));
            config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minIdle")));
            config.setIdleTimeout(Long.parseLong(props.getProperty("db.pool.idleTimeout")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("db.pool.connectionTimeout")));

            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);

        } catch (IOException e) {
            throw new RuntimeException("Erro ao carregar database.properties: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    private dbFactory() {}
}