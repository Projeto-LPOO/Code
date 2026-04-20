

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class dbFactory {
	private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USUARIO = "postgres";
    private static final String SENHA = "cazum8br";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}
