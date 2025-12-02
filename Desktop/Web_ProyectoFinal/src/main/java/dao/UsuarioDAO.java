package dao;

import config.Conexion;
import model.Usuario;
import model.Producto;
import java.sql.*;
import java.util.*;


public class UsuarioDAO {

    // Método de Login
    public Usuario validar(String correo, String contrasena) {
    Usuario usuario = null;
    // CORRECCIÓN: Se añade "AND estado = 'activo'" a la consulta SQL
    String sql = "SELECT * FROM Usuarios WHERE correo = ? AND contrasena = ? AND estado = 'activo'";
    
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, correo);
        ps.setString(2, contrasena);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId_usuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setDireccion(rs.getString("direccion"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEstado(rs.getString("estado"));
                
                System.out.println("DEBUG: Login exitoso. ID cargado: " + usuario.getId_usuario());
            }
        }
    } catch (Exception e) {
        System.err.println("Error al validar usuario: " + e.getMessage());
        e.printStackTrace();
    }
    return usuario;
}

    // Método de Registro (INSERT)
    public boolean verificarCorreoExistente(String correo) {
    String sql = "SELECT id_usuario FROM Usuarios WHERE correo = ?";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, correo);
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next(); // Retorna true si encuentra al menos una fila
        }
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

    public boolean registrar(Usuario usuario) {
        String sql = "INSERT INTO Usuarios (nombre, apellido, correo, contrasena, telefono, direccion, rol, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection()) {
            con.setAutoCommit(true);
            try(PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, usuario.getNombre());
                ps.setString(2, usuario.getApellido());
                ps.setString(3, usuario.getCorreo());
                ps.setString(4, usuario.getContrasena());
                ps.setString(5, usuario.getTelefono());
                ps.setString(6, usuario.getDireccion());
                ps.setString(7, "cliente");
                ps.setString(8, "activo");

                int filasAfectadas = ps.executeUpdate();
                System.out.println("DAO Registrar - Filas afectadas por el INSERT: " + filasAfectadas);
                return filasAfectadas > 0;
            }
        } catch (Exception e) {
            System.err.println("DAO Registrar - ERROR GRAVE: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Método para contar clientes (estadística)
    public int contarClientesActivos() {
        int total = 0;
        String sql = "SELECT COUNT(id_usuario) as total FROM Usuarios WHERE rol = 'cliente' AND estado = 'activo'";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    
    // Método para obtener usuario por ID (CRUD para Admin/General)
    public Usuario obtenerPorId(int id) {
        Usuario usuario = null;
        String sql = "SELECT * FROM Usuarios WHERE id_usuario = ?";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    // *** CORRECCIÓN: Asignar todos los campos ***
                    usuario.setId_usuario(rs.getInt("id_usuario"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setDireccion(rs.getString("direccion"));
                    usuario.setRol(rs.getString("rol"));
                    usuario.setEstado(rs.getString("estado"));
                    // Fin de la corrección
                }
            }
        } catch (Exception e) {
            System.err.println("Error al obtener usuario por ID: " + e.getMessage());
            e.printStackTrace();
        }
        return usuario;
    }
    
   public boolean actualizarUsuario(Usuario usuario, String nuevaContrasena) {
        String sql;
        boolean actualizarPass = (nuevaContrasena != null && !nuevaContrasena.isEmpty());

        if (actualizarPass) {
            // Se actualizan 5 campos + contrasena = 6 campos a SET, 7 parámetros en total (incluyendo el WHERE)
            sql = "UPDATE Usuarios SET nombre=?, apellido=?, contrasena=?, telefono=?, direccion=? WHERE id_usuario=?";
        } else {
            // Se actualizan 5 campos, 6 parámetros en total (incluyendo el WHERE)
            sql = "UPDATE Usuarios SET nombre=?, apellido=?, telefono=?, direccion=? WHERE id_usuario=?";
        }
        
        System.out.println("DEBUG DAO: SQL UPDATE a ejecutar: " + sql);

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;
            ps.setString(index++, usuario.getNombre());
            ps.setString(index++, usuario.getApellido());
            
            if (actualizarPass) {
                // **CRÍTICO:** Asignar la nueva contraseña. (RECUERDA HASHEAR EN PRODUCCIÓN)
                ps.setString(index++, nuevaContrasena); 
                System.out.println("DEBUG DAO: Contraseña será actualizada.");
            }
            
            ps.setString(index++, usuario.getTelefono());
            ps.setString(index++, usuario.getDireccion());
            
            // Asignación final del ID para la cláusula WHERE
            ps.setInt(index, usuario.getId_usuario()); 

            int filasAfectadas = ps.executeUpdate();
            
            System.out.println("DEBUG DAO: ID de usuario actualizado: " + usuario.getId_usuario());
            System.out.println("DEBUG DAO: Filas afectadas: " + filasAfectadas);

            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("SQL ERROR al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Método de "Eliminar" (Desactivar)
public boolean eliminarUsuario(int idUsuario) {
    // Cambiamos el estado de 'activo' a 'inactivo'
    String sql = "UPDATE Usuarios SET estado = 'inactivo' WHERE id_usuario = ?";
    
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        int filasAfectadas = ps.executeUpdate();
        
        System.out.println("DEBUG: Usuario ID " + idUsuario + " desactivado. Filas: " + filasAfectadas);
        
        return filasAfectadas > 0;

    } catch (SQLException e) {
        System.err.println("Error al eliminar usuario: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

public List<Usuario> obtenerClientesRecientes15Dias() {
    List<Usuario> clientes = new ArrayList<>();
    // La consulta ahora usa un intervalo de fechas
    String sql = "SELECT nombre, apellido, correo, estado FROM Usuarios WHERE rol = 'cliente' AND fecha_registro >= CURDATE() - INTERVAL 15 DAY ORDER BY fecha_registro DESC";
    
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            Usuario cliente = new Usuario();
            cliente.setNombre(rs.getString("nombre"));
            cliente.setApellido(rs.getString("apellido"));
            cliente.setCorreo(rs.getString("correo"));
            cliente.setEstado(rs.getString("estado"));
            clientes.add(cliente);
        }
    } catch (Exception e) {
        System.err.println("Error al obtener clientes recientes: " + e.getMessage());
        e.printStackTrace();
    }
    return clientes;
    
}

public boolean crearProducto(Producto producto) {
    String sql = "INSERT INTO Productos (nombre, descripcion, precio, stock, id_categoria, imagen, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, producto.getNombre());
        ps.setString(2, producto.getDescripcion());
        ps.setBigDecimal(3, producto.getPrecio());
        ps.setInt(4, producto.getStock());
        ps.setInt(5, producto.getId_categoria());
        ps.setString(6, producto.getImagen());
        ps.setString(7, "activo"); // Los nuevos productos siempre se crean como activos
        
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        System.err.println("Error al crear el producto: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

public List<Usuario> obtenerTodosPorRol(String rol) {
    List<Usuario> usuarios = new ArrayList<>();
    String sql = "SELECT * FROM Usuarios WHERE rol = ? ORDER BY fecha_registro DESC";
    
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, rol);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId_usuario(rs.getInt("id_usuario"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setCorreo(rs.getString("correo"));
                u.setTelefono(rs.getString("telefono"));
                u.setDireccion(rs.getString("direccion"));
                u.setEstado(rs.getString("estado"));
                usuarios.add(u);
            }
        }
    } catch (Exception e) {
        System.err.println("Error al obtener usuarios por rol: " + e.getMessage());
        e.printStackTrace();
    }
    return usuarios;
}

public boolean eliminarUsuarioFisico(int idUsuario) {
    String sql = "DELETE FROM Usuarios WHERE id_usuario = ?";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idUsuario);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.err.println("Error al eliminar físicamente al usuario: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

public boolean desactivarUsuario(int idUsuario) {
        String sql = "UPDATE Usuarios SET estado = 'inactivo' WHERE id_usuario = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

public boolean activarUsuario(int idUsuario) {
        String sql = "UPDATE Usuarios SET estado = 'activo' WHERE id_usuario = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

public boolean crearAdmin(Usuario admin) {
    // La consulta SQL inserta un nuevo usuario con el rol 'admin' y estado 'activo' por defecto
    String sql = "INSERT INTO Usuarios (nombre, apellido, correo, contrasena, telefono, direccion, rol, estado) VALUES (?, ?, ?, ?, ?, ?, 'admin', 'activo')";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, admin.getNombre());
        ps.setString(2, admin.getApellido());
        ps.setString(3, admin.getCorreo());
        // IMPORTANTE: Recuerda hashear la contraseña en una aplicación real
        ps.setString(4, admin.getContrasena());
        ps.setString(5, admin.getTelefono());
        ps.setString(6, admin.getDireccion());
        
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        System.err.println("Error al crear el admin: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

// NUEVO MÉTODO PARA FAVORITOS
    /**
     * Agrega un producto a la lista de favoritos de un usuario.
     * @param idUsuario ID del usuario.
     * @param idProducto ID del producto a agregar.
     * @return true si se agregó correctamente, false si ya existía o hubo un error.
     */
    public boolean agregarFavorito(int idUsuario, int idProducto) {
        // Consulta para verificar si el favorito ya existe
        String CHECK_SQL = "SELECT count(*) FROM favoritos WHERE id_usuario = ? AND id_producto = ?";
        // Consulta para insertar el favorito
        String INSERT_SQL = "INSERT INTO favoritos (id_usuario, id_producto) VALUES (?, ?)";
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = Conexion.getConnection();
            
            // 1. Verificar si el favorito ya existe
            ps = con.prepareStatement(CHECK_SQL);
            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            rs = ps.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Ya existe, no se inserta. Retorna falso para indicar que no fue una inserción.
                return false; 
            }
            
            // Cerrar el ResultSet y PreparedStatement de la verificación
            // Es buena práctica cerrar los recursos internos si se reusan las variables
            if (rs != null) rs.close();
            if (ps != null) ps.close(); 
            
            // 2. Insertar el favorito
            ps = con.prepareStatement(INSERT_SQL);
            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            
            int filasAfectadas = ps.executeUpdate();
            
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            // Error de conexión, permisos, etc.
            System.err.println("Error al agregar favorito: " + e.getMessage());
            return false;
        } finally {
            // Asegúrate de cerrar los recursos
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar recursos en agregarFavorito: " + e.getMessage());
            }
        }
    }
    
    /**
     * Obtiene todos los IDs de productos que un usuario ha marcado como favoritos.
     * @param idUsuario ID del usuario.
     * @return Un Set de IDs de productos.
     */
    public Set<Integer> obtenerIdsFavoritosPorUsuario(int idUsuario) {
        Set<Integer> favoritos = new HashSet<>();
        String sql = "SELECT id_producto FROM favoritos WHERE id_usuario = ?";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    favoritos.add(rs.getInt("id_producto"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener IDs de favoritos: " + e.getMessage());
        }
        return favoritos;
    }
    
    /**
     * Elimina un producto de la lista de favoritos del usuario.
     * @param idUsuario ID del usuario.
     * @param idProducto ID del producto a eliminar.
     * @return true si se eliminó correctamente.
     */
    public boolean eliminarFavorito(int idUsuario, int idProducto) {
        String sql = "DELETE FROM favoritos WHERE id_usuario = ? AND id_producto = ?";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar favorito: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Obtiene una lista de objetos Producto que el usuario ha marcado como favoritos.
     * @param idUsuario ID del usuario.
     * @return Lista de productos favoritos.
     */
    public List<Producto> obtenerProductosFavoritosPorUsuario(int idUsuario) {
        List<Producto> favoritos = new ArrayList<>();
        // Consulta SQL que une las tablas favoritos y productos para obtener los detalles
        String sql = "SELECT p.* FROM productos p " +
                     "INNER JOIN favoritos f ON p.id_producto = f.id_producto " +
                     "WHERE f.id_usuario = ? AND p.estado = 'activo' " +
                     "ORDER BY f.fecha_agregado DESC";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto p = new Producto();
                    p.setId_producto(rs.getInt("id_producto"));
                    p.setNombre(rs.getString("nombre"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setPrecio(rs.getBigDecimal("precio"));
                    p.setStock(rs.getInt("stock"));
                    p.setId_categoria(rs.getInt("id_categoria"));
                    p.setImagen(rs.getString("imagen"));
                    favoritos.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener productos favoritos: " + e.getMessage());
        }
        return favoritos;
    }

}