package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    // URL actualizada para soportar caracteres especiales como la 'ñ'
    private static final String URL = "jdbc:mysql://localhost:3306/PeruvianStyleDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER = "root"; 
    private static final String PASS = "mj123456789"; // Tu contraseña

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error al conectar a la BD: " + e.getMessage());
            e.printStackTrace(); // Imprime el error completo para un mejor diagnóstico
        }
        return con;
    }
}