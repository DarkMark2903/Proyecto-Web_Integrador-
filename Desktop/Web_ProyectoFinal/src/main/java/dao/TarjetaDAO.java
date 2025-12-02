package dao;

import config.Conexion;
import model.Tarjeta;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TarjetaDAO {
    
    private static final String INSERT_TARJETA = "INSERT INTO tarjetas (id_usuario, ultimos_digitos, nombre_titular, fecha_expiracion, tipo) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_TARJETAS_BY_USER = "SELECT * FROM tarjetas WHERE id_usuario = ? ORDER BY id_tarjeta ASC"; // Ordena por ID (la primera es la más antigua)
    private static final String DELETE_TARJETA = "DELETE FROM tarjetas WHERE id_tarjeta = ? AND id_usuario = ?";
    
    /**
     * Registra una tarjeta de forma simulada.
     */
    public boolean registrarTarjeta(int idUsuario, String ultimosDigitos, String nombreTitular, String fechaExpiracion, String tipo) {
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_TARJETA)) {
            
            ps.setInt(1, idUsuario);
            ps.setString(2, ultimosDigitos);
            ps.setString(3, nombreTitular);
            ps.setString(4, fechaExpiracion);
            ps.setString(5, tipo);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al registrar tarjeta: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Obtiene la lista de tarjetas de un usuario para su visualización.
     */
    public List<Tarjeta> obtenerTarjetasPorUsuario(int idUsuario) {
        List<Tarjeta> listaTarjetas = new ArrayList<>();
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_TARJETAS_BY_USER)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tarjeta t = new Tarjeta();
                    t.setId_tarjeta(rs.getInt("id_tarjeta"));
                    t.setUltimosDigitos(rs.getString("ultimos_digitos"));
                    t.setNombreTitular(rs.getString("nombre_titular"));
                    t.setFechaExpiracion(rs.getString("fecha_expiracion"));
                    t.setTipo(rs.getString("tipo"));
                    listaTarjetas.add(t);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener tarjetas por usuario: " + e.getMessage());
            e.printStackTrace();
        }
        return listaTarjetas;
    }

    /**
     * Elimina una tarjeta por ID, verificando que pertenezca al usuario.
     */
    public boolean eliminarTarjeta(int idTarjeta, int idUsuario) {
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_TARJETA)) {
            
            ps.setInt(1, idTarjeta);
            ps.setInt(2, idUsuario);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar tarjeta: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}