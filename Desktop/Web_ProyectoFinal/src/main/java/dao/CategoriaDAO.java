package dao;

import config.Conexion;
import model.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {
    
    public List<Categoria> obtenerTodas() {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "SELECT * FROM Categorias ORDER BY nombre_categoria";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId_categoria(rs.getInt("id_categoria"));
                c.setNombre_categoria(rs.getString("nombre_categoria"));
                c.setDescripcion(rs.getString("descripcion"));
                categorias.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categorias;
    }

    public boolean crearCategoria(String nombre, String descripcion) {
        String sql = "INSERT INTO Categorias (nombre_categoria, descripcion) VALUES (?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al crear categoría: " + e.getMessage());
            return false;
        }
    }

    // NUEVO: Actualizar
    public boolean actualizarCategoria(int id, String nombre, String descripcion) {
        String sql = "UPDATE Categorias SET nombre_categoria=?, descripcion=? WHERE id_categoria=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // NUEVO: Eliminar
    public boolean eliminarCategoria(int id) {
        String sql = "DELETE FROM Categorias WHERE id_categoria=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Fallará si hay productos asociados (FK)
            System.err.println("Error al eliminar categoría (puede tener productos): " + e.getMessage());
            return false;
        }
    }
}