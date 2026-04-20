
import java.sql.Connection;

public class test {
    public static void main(String[] args) {
        try {
            Connection conn = dbFactory.getConnection();
            System.out.println("Conectado com sucesso!");
            conn.close();
        } catch (Exception e) {
            System.out.println("Erro: " + e.getMessage());
            e.printStackTrace();
        }
    }
}