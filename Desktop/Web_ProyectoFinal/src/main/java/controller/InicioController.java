package controller;

import dao.PedidoDAO;
import dao.UsuarioDAO; // Se mantiene por si planeas usarlo para favoritos u otra lógica
import model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/inicio")
public class InicioController extends HttpServlet {

    private final PedidoDAO pedidoDAO = new PedidoDAO();
    // private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener los 4 productos destacados (Ventas Históricas o Recientes)
        List<Producto> productosTop = pedidoDAO.obtenerTopProductosVendidos(4);
        
        // --- INICIO DE LA CORRECCIÓN ---
        
        // 2. Pasar la lista de productos al JSP para que el <c:forEach> funcione
        request.setAttribute("productosTop", productosTop);
        
        // 3. Importante: Redirigir la solicitud al archivo JSP visual
        // Esto hace que el navegador muestre 'inicio.jsp' con los datos cargados.
        request.getRequestDispatcher("/inicio.jsp").forward(request, response);
        
        // --- FIN DE LA CORRECCIÓN ---
    }
}