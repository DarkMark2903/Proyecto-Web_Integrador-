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
        
        List<Pedido> listaPedidos = pedidoDAO.obtenerTodos();
        
        if (listaPedidos != null) {
            for (Pedido p : listaPedidos) {
                List<DetallePedido> detalles = pedidoDAO.obtenerDetallesPorPedido(p.getId_pedido());
                p.setDetalles(detalles);
            }
        }

        request.setAttribute("listaPedidos", listaPedidos);
        request.getRequestDispatcher("/administrador/gestionar_ventas.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión Admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        if ("confirmarPago".equals(accion)) {
            try {
                int idPedido = Integer.parseInt(request.getParameter("idPedido"));
                // Actualizar estado a 'pagado'
                pedidoDAO.actualizarEstadoPedido(idPedido, "pagado");
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // Redirigir de nuevo a la lista
        response.sendRedirect(request.getContextPath() + "/admin/gestionar-ventas");
    }
}