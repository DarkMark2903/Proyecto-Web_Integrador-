package controller;

import dao.PedidoDAO;
import model.Usuario;
import model.Pedido;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/mi-cuenta")
public class CuentaController extends HttpServlet {
    private final PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session.getAttribute("mensaje") != null) {
        request.setAttribute("mensaje", session.getAttribute("mensaje"));
        session.removeAttribute("mensaje"); // Eliminarlo de la sesión para que no se muestre dos veces
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        // List<Pedido> historialPedidos = pedidoDAO.obtenerPorUsuario(usuario.getId()); // Descomentar cuando la función de compra esté lista
        // request.setAttribute("historial", historialPedidos);
        
        request.getRequestDispatcher("/cliente/cuenta.jsp").forward(request, response);
    }
}