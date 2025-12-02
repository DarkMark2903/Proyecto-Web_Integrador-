package dao;

import config.Conexion;
import model.Categoria;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
                Categoria cat = new Categoria();
                cat.setId_categoria(rs.getInt("id_categoria"));
                cat.setNombre_categoria(rs.getString("nombre_categoria"));
                categorias.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categorias;
    }
}