package controller;

import dao.ProductoDAO;
import dao.PedidoDAO;
import dao.UsuarioDAO;
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
        
        // Validar rol
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!"admin".equals(usuario.getRol()) && !"empleado".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 1. Obtener KPIs principales
        int productosDisponibles = productoDAO.contarActivos();
        int ventasHoy = pedidoDAO.contarVentasHoy();
        int clientesRegistrados = usuarioDAO.contarClientesActivos();
        double ingresosHoy = pedidoDAO.calcularIngresosHoy();
        
        // 2. Obtener datos para la tabla de clientes recientes
        List<Usuario> clientesRecientes = usuarioDAO.obtenerClientesRecientes15Dias();
        
        // 3. Obtener datos para el GRÁFICO (Ventas últimos 7 días)
        List<Double> ventas7Dias = pedidoDAO.obtenerVentasUltimos7Dias();
        
        // 4. Enviar todo al JSP
        request.setAttribute("kpiProductos", productosDisponibles);
        request.setAttribute("kpiVentas", ventasHoy);
        request.setAttribute("kpiClientes", clientesRegistrados);
        request.setAttribute("kpiIngresos", ingresosHoy);
        request.setAttribute("clientesRecientes", clientesRecientes);
        request.setAttribute("ventas7Dias", ventas7Dias); // Datos dinámicos para el gráfico
        
        request.getRequestDispatcher("/administrador/admin_dashboard.jsp").forward(request, response);
    }
}