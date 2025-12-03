package controller;

import dao.ProductoDAO;
import dao.PedidoDAO;
import dao.UsuarioDAO;
import model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Usuario;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!"admin".equals(usuario.getRol()) && !"empleado".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 1. KPIs
        int productosDisponibles = productoDAO.contarActivos();
        int ventasHoy = pedidoDAO.contarVentasHoy();
        int clientesRegistrados = usuarioDAO.contarClientesActivos();
        double ingresosHoy = pedidoDAO.calcularIngresosHoy();
        
        // 2. Tablas y Gráficos
        List<Usuario> clientesRecientes = usuarioDAO.obtenerClientesRecientes15Dias();
        List<Double> ventas7Dias = pedidoDAO.obtenerVentasUltimos7Dias();
        
        // 3. Top Productos Vendidos (HISTÓRICO TOTAL, límite 5)
        List<Producto> productosTop = pedidoDAO.obtenerTopProductosVendidos(5);
        
        request.setAttribute("kpiProductos", productosDisponibles);
        request.setAttribute("kpiVentas", ventasHoy);
        request.setAttribute("kpiClientes", clientesRegistrados);
        request.setAttribute("kpiIngresos", ingresosHoy);
        request.setAttribute("clientesRecientes", clientesRecientes);
        request.setAttribute("ventas7Dias", ventas7Dias);
        request.setAttribute("productosTop", productosTop);
        
        request.getRequestDispatcher("/administrador/admin_dashboard.jsp").forward(request, response);
    }
}