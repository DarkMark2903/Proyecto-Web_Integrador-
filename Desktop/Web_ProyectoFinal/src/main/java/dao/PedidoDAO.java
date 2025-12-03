package dao;

import config.Conexion;
import model.Pedido;
import model.DetallePedido;
import model.CarritoItem;
import model.Producto;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.math.BigDecimal;

public class PedidoDAO {

    // --- MÉTODOS DE CONSULTA ---

    public List<Pedido> obtenerPorUsuario(int idUsuario) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM Pedidos WHERE id_usuario = ? ORDER BY fecha_pedido DESC";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = new Pedido();
                    p.setId_pedido(rs.getInt("id_pedido"));
                    p.setId_usuario(rs.getInt("id_usuario"));
                    p.setFecha_pedido(rs.getTimestamp("fecha_pedido"));
                    p.setEstado(rs.getString("estado"));
                    p.setTotal(rs.getBigDecimal("total"));
                    pedidos.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return pedidos;
    }
    
    public List<DetallePedido> obtenerDetallesPorPedido(int idPedido) {
        List<DetallePedido> detalles = new ArrayList<>();
        String sql = "SELECT p.nombre, p.imagen, dp.cantidad, dp.precio_unitario, dp.subtotal " +
                     "FROM detalle_pedido dp " +
                     "JOIN productos p ON dp.id_producto = p.id_producto " +
                     "WHERE dp.id_pedido = ?";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DetallePedido dp = new DetallePedido();
                    dp.setNombreProducto(rs.getString("nombre"));
                    dp.setImagen(rs.getString("imagen"));
                    dp.setCantidad(rs.getInt("cantidad"));
                    dp.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                    dp.setSubtotal(rs.getBigDecimal("subtotal"));
                    detalles.add(dp);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return detalles;
    }

    public List<Pedido> obtenerTodos() {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre, u.apellido FROM Pedidos p JOIN Usuarios u ON p.id_usuario = u.id_usuario ORDER BY p.fecha_pedido DESC";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Pedido p = new Pedido();
                p.setId_pedido(rs.getInt("id_pedido"));
                p.setId_usuario(rs.getInt("id_usuario"));
                p.setFecha_pedido(rs.getTimestamp("fecha_pedido"));
                p.setEstado(rs.getString("estado"));
                p.setTotal(rs.getBigDecimal("total"));
                p.setNombreCliente(rs.getString("nombre") + " " + rs.getString("apellido"));
                pedidos.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return pedidos;
    }

    // --- MÉTODOS DASHBOARD ---
    
    public double calcularIngresosTotales() {
        double total = 0.0;
        String sql = "SELECT SUM(total) as ingresos FROM Pedidos WHERE estado != 'cancelado'";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) { total = rs.getDouble("ingresos"); }
        } catch (Exception e) { e.printStackTrace(); } return total;
    }

    public int contarVentasTotales() {
        int total = 0;
        String sql = "SELECT COUNT(id_pedido) as total FROM Pedidos WHERE estado != 'cancelado'";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) { total = rs.getInt("total"); }
        } catch (Exception e) { e.printStackTrace(); } return total;
    }

    public int contarClientesUnicos() {
        int total = 0;
        String sql = "SELECT COUNT(DISTINCT id_usuario) as total FROM Pedidos";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) { total = rs.getInt("total"); }
        } catch (Exception e) { e.printStackTrace(); } return total;
    }

    public List<Double> obtenerVentasUltimos7Dias() {
        List<Double> ventasDiarias = new ArrayList<>(Collections.nCopies(7, 0.0));
        String sql = "SELECT DAYOFWEEK(fecha_pedido) as dia_semana, SUM(total) as total_dia " +
                     "FROM Pedidos " +
                     "WHERE fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " + 
                     "AND estado != 'cancelado' " +
                     "GROUP BY dia_semana";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int dia = rs.getInt("dia_semana");
                if (dia >= 1 && dia <= 7) {
                    ventasDiarias.set(dia - 1, rs.getDouble("total_dia"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ventasDiarias;
    }

    public int contarVentasHoy() {
        int total = 0;
        String sql = "SELECT COUNT(id_pedido) as total FROM Pedidos WHERE DATE(fecha_pedido) = CURDATE() AND estado != 'cancelado'";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) { total = rs.getInt("total"); }
        } catch (Exception e) { e.printStackTrace(); } return total;
    }

    public double calcularIngresosHoy() {
        double total = 0.0;
        String sql = "SELECT SUM(total) as ingresos FROM Pedidos WHERE DATE(fecha_pedido) = CURDATE() AND estado != 'cancelado'";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) { total = rs.getDouble("ingresos"); }
        } catch (Exception e) { e.printStackTrace(); } return total;
    }
    
    // --- MÉTODO MEJORADO: TOP PRODUCTOS CON ESTRATEGIA DE RESPALDO ---
    public List<Producto> obtenerTopProductosVendidos(int limite) {
        List<Producto> productos = new ArrayList<>();
        
        // 1. Intentar obtener por historial de ventas (Ranking Real)
        String sqlVentas = "SELECT p.id_producto, p.nombre, p.precio, p.imagen, p.descripcion, p.stock, SUM(dp.cantidad) as total_vendido " +
                     "FROM detalle_pedido dp " +
                     "JOIN pedidos ped ON dp.id_pedido = ped.id_pedido " +
                     "JOIN productos p ON dp.id_producto = p.id_producto " +
                     "WHERE ped.estado != 'cancelado' " +
                     "GROUP BY p.id_producto " +
                     "ORDER BY total_vendido DESC " +
                     "LIMIT ?";
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlVentas)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productos.add(mapRowToProductoSimple(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 2. FALLBACK: Si no hay ventas (lista vacía), cargar los productos más recientes
        // Esto evita que el inicio.jsp salga vacío
        if (productos.isEmpty()) {
            String sqlRecientes = "SELECT * FROM productos WHERE estado = 'activo' ORDER BY id_producto DESC LIMIT ?";
            try (Connection con = Conexion.getConnection();
                 PreparedStatement ps = con.prepareStatement(sqlRecientes)) {
                ps.setInt(1, limite);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        productos.add(mapRowToProductoSimple(rs));
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }
        }
        
        return productos;
    }

    // Helper para mapear ResultSet a Producto (evitando duplicidad y errores de nulos)
    private Producto mapRowToProductoSimple(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setId_producto(rs.getInt("id_producto"));
        p.setNombre(rs.getString("nombre"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setImagen(rs.getString("imagen"));
        // Manejo seguro de null para descripción
        String desc = rs.getString("descripcion");
        p.setDescripcion(desc != null ? desc : "");
        p.setStock(rs.getInt("stock"));
        return p;
    }

    // --- MÉTODO TRANSACCIONAL ---
    public boolean crearPedido(Pedido pedido, List<CarritoItem> items, String direccionEnvio, String metodoPago) {
        String INSERT_DIRECCION = "INSERT INTO direcciones (id_usuario, direccion, tipo, pais) VALUES (?, ?, 'envio', 'Perú')";
        String INSERT_PEDIDO = "INSERT INTO pedidos (id_usuario, id_direccion, estado, total) VALUES (?, ?, ?, ?)";
        String INSERT_DETALLE = "INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        String UPDATE_STOCK = "UPDATE productos SET stock = stock - ? WHERE id_producto = ? AND stock >= ?"; 
        String DEACTIVATE_PRODUCT = "UPDATE productos SET estado = 'inactivo' WHERE id_producto = ? AND stock = 0";
        String INSERT_PAGO = "INSERT INTO pagos (id_pedido, metodo_pago, monto, estado_pago) VALUES (?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement psDir = null, psPedido = null, psDetalle = null, psStock = null, psDeactivate = null, psPago = null;
        ResultSet rsDir = null, rsPed = null;
        
        try {
            con = Conexion.getConnection();
            con.setAutoCommit(false);
            
            psDir = con.prepareStatement(INSERT_DIRECCION, Statement.RETURN_GENERATED_KEYS);
            psDir.setInt(1, pedido.getId_usuario());
            psDir.setString(2, direccionEnvio);
            psDir.executeUpdate();
            rsDir = psDir.getGeneratedKeys();
            int idDireccionGenerada = (rsDir.next()) ? rsDir.getInt(1) : 0;

            psPedido = con.prepareStatement(INSERT_PEDIDO, Statement.RETURN_GENERATED_KEYS);
            psPedido.setInt(1, pedido.getId_usuario());
            psPedido.setInt(2, idDireccionGenerada);
            psPedido.setString(3, "pagado"); 
            psPedido.setBigDecimal(4, pedido.getTotal());
            psPedido.executeUpdate();
            rsPed = psPedido.getGeneratedKeys();
            int idPedido = (rsPed.next()) ? rsPed.getInt(1) : 0;
            pedido.setId_pedido(idPedido);
            
            psDetalle = con.prepareStatement(INSERT_DETALLE);
            psStock = con.prepareStatement(UPDATE_STOCK);
            psDeactivate = con.prepareStatement(DEACTIVATE_PRODUCT);

            for (CarritoItem item : items) {
                int idProducto = item.getProducto().getId_producto();
                int cantidad = item.getCantidad();

                psStock.setInt(1, cantidad);
                psStock.setInt(2, idProducto);
                psStock.setInt(3, cantidad);
                if (psStock.executeUpdate() == 0) throw new SQLException("Stock insuficiente para el producto ID: " + idProducto);

                psDeactivate.setInt(1, idProducto);
                psDeactivate.executeUpdate();

                psDetalle.setInt(1, idPedido);
                psDetalle.setInt(2, idProducto);
                psDetalle.setInt(3, cantidad);
                psDetalle.setBigDecimal(4, item.getProducto().getPrecio());
                psDetalle.addBatch();
            }
            psDetalle.executeBatch();

            psPago = con.prepareStatement(INSERT_PAGO);
            psPago.setInt(1, idPedido);
            psPago.setString(2, metodoPago);
            psPago.setBigDecimal(3, pedido.getTotal());
            psPago.setString(4, "aprobado"); 
            psPago.executeUpdate();
            
            con.commit();
            return true;
        } catch (SQLException e) {
            try { if (con != null) con.rollback(); } catch (SQLException ex) { }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rsDir != null) rsDir.close();
                if (rsPed != null) rsPed.close();
                if (psDir != null) psDir.close();
                if (psPedido != null) psPedido.close();
                if (psDetalle != null) psDetalle.close();
                if (psStock != null) psStock.close();
                if (psDeactivate != null) psDeactivate.close();
                if (psPago != null) psPago.close();
                if (con != null) con.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}