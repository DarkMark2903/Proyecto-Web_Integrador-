package controller;

import dao.PedidoDAO;
import model.Pedido;
import model.DetallePedido;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/mis-pedidos") 
public class MisPedidosController extends HttpServlet {

    private final PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        
        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        try {
            // 1. Obtener la lista de pedidos
            List<Pedido> listaPedidos = pedidoDAO.obtenerPorUsuario(usuarioLogueado.getId_usuario());
            
            // 2. Cargar los detalles para cada pedido (necesario para el modal)
            for (Pedido p : listaPedidos) {
                List<DetallePedido> detalles = pedidoDAO.obtenerDetallesPorPedido(p.getId_pedido());
                p.setDetalles(detalles);
            }
            
            request.setAttribute("pedidos", listaPedidos);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el historial de pedidos.");
        }
        
        request.getRequestDispatcher("/cliente/mis_pedidos.jsp").forward(request, response);
    }
}