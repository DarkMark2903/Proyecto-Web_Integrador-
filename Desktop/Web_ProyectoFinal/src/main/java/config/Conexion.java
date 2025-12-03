package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static Connection con;

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 1. Intentamos leer las credenciales de la Nube (Variables de Entorno)
            String dbUrl = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASSWORD");

            if (dbUrl != null && dbUser != null && dbPass != null) {
                // Si existen, estamos en Railway (o producción)
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            } else {
                // 2. Si no existen, estamos en tu PC (Localhost)
                // Ajusta aquí tu usuario/password local si es diferente a root/root
                String urlLocal = "jdbc:mysql://localhost:3306/bd_proyecto?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
                con = DriverManager.getConnection(urlLocal, "root", "root");
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("--- Error de Conexión en Conexion.java ---");
            System.err.println("Mensaje: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}