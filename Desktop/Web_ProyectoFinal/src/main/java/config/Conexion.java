package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    // FIX: Cambiamos UTC por America/Lima para que Java interprete bien la hora local
    private static final String URL = "jdbc:mysql://localhost:3306/PeruvianStyleDB?useSSL=false&serverTimezone=America/Lima&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
    private static final String USER = "root"; 
    private static final String PASS = "mj123456789"; // Tu contraseña

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error al conectar a la BD: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}