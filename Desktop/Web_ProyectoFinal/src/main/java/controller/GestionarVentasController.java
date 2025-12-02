package controller;

import dao.PedidoDAO;
import model.DetallePedido;
import model.Pedido;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/gestionar-ventas")
public class GestionarVentasController extends HttpServlet {
    private final PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        Usuario user = (Usuario) session.getAttribute("usuario");
        if (!"admin".equals(user.getRol()) && !"empleado".equals(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 1. Obtener la lista completa de pedidos
        List<Pedido> listaPedidos = pedidoDAO.obtenerTodos();
        
        // 2. CRÍTICO: Recorrer cada pedido y cargar sus productos (detalles)
        // Esto es necesario para que el modal "Ver Detalle" muestre qué se compró
        if (listaPedidos != null) {
            for (Pedido p : listaPedidos) {
                List<DetallePedido> detalles = pedidoDAO.obtenerDetallesPorPedido(p.getId_pedido());
                p.setDetalles(detalles);
            }
        }

        // 3. Enviar la lista procesada al JSP
        request.setAttribute("listaPedidos", listaPedidos);
        
        request.getRequestDispatcher("/administrador/gestionar_ventas.jsp").forward(request, response);
    }
}