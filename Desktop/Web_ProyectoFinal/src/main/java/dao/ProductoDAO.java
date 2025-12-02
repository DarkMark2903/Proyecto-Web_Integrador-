package dao;

import config.Conexion;
import model.Producto;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    // --- MÉTODOS DE CONSULTA Y MAPEO ---

    public List<Producto> obtenerTodos() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM Productos ORDER BY nombre"; 
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                productos.add(mapRowToProducto(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productos;
    }

    public Producto obtenerPorId(int id) {
        Producto producto = null;
        String sql = "SELECT * FROM Productos WHERE id_producto = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    producto = mapRowToProducto(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return producto;
    }

    // --- MÉTODOS CRUD ---

    public boolean crearProducto(Producto p) {
        String sql = "INSERT INTO Productos (nombre, descripcion, precio, stock, id_categoria, imagen, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setBigDecimal(3, p.getPrecio());
            ps.setInt(4, p.getStock());
            ps.setInt(5, p.getId_categoria());
            ps.setString(6, p.getImagen());
            ps.setString(7, "activo");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // NUEVO MÉTODO AGREGADO: ACTUALIZAR PRODUCTO
    public boolean actualizarProducto(Producto p) {
        // Actualiza todos los campos. Si la imagen es null/vacía, se debería manejar en el controlador para no sobrescribirla si no se desea.
        // Aquí asumimos que el objeto 'p' ya viene con la imagen correcta (nueva o la anterior).
        String sql = "UPDATE Productos SET nombre=?, descripcion=?, precio=?, stock=?, id_categoria=?, imagen=? WHERE id_producto=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setBigDecimal(3, p.getPrecio());
            ps.setInt(4, p.getStock());
            ps.setInt(5, p.getId_categoria());
            ps.setString(6, p.getImagen());
            ps.setInt(7, p.getId_producto());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cambiarEstadoProducto(int idProducto, String nuevoEstado) {
        String sql = "UPDATE Productos SET estado = ? WHERE id_producto = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idProducto);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarProductoFisico(int idProducto) {
        String sql = "DELETE FROM Productos WHERE id_producto = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // --- OTROS MÉTODOS ---
    
    public int contarActivos() {
        int total = 0;
        String sql = "SELECT COUNT(id_producto) as total FROM Productos WHERE estado = 'activo'";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    public List<Producto> listarConFiltros(String busqueda, int categoriaId, String orden) {
        List<Producto> productos = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Productos WHERE estado = 'activo'");

        if (busqueda != null && !busqueda.trim().isEmpty()) {
            sql.append(" AND nombre LIKE ?");
        }
        if (categoriaId > 0) {
            sql.append(" AND id_categoria = ?");
        }

        if (orden != null) {
            switch (orden) {
                case "precio_asc": sql.append(" ORDER BY precio ASC"); break;
                case "precio_desc": sql.append(" ORDER BY precio DESC"); break;
                case "nombre_asc": sql.append(" ORDER BY nombre ASC"); break;
                default: sql.append(" ORDER BY id_producto DESC"); break; 
            }
        } else {
            sql.append(" ORDER BY id_producto DESC");
        }

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            if (busqueda != null && !busqueda.trim().isEmpty()) {
                ps.setString(index++, "%" + busqueda.trim() + "%");
            }
            if (categoriaId > 0) {
                ps.setInt(index++, categoriaId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productos.add(mapRowToProducto(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productos;
    }
    
    private Producto mapRowToProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setId_producto(rs.getInt("id_producto"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setStock(rs.getInt("stock"));
        p.setId_categoria(rs.getInt("id_categoria"));
        p.setImagen(rs.getString("imagen"));
        p.setEstado(rs.getString("estado"));
        try { p.setFecha_creacion(rs.getTimestamp("fecha_creacion")); } catch (SQLException e) {}
        return p;
    }
    
    public boolean actualizarStock(int idProducto, int cantidadVendida) {
        String sql = "UPDATE productos SET stock = stock - ? WHERE id_producto = ? AND stock >= ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cantidadVendida);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidadVendida);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }
}