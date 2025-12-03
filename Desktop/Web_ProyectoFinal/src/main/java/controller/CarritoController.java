package controller;

import model.CarritoItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/carrito")
public class CarritoController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Solo muestra el JSP
        request.getRequestDispatcher("/carrito.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String accion = request.getParameter("accion");
        
        if ("eliminar".equals(accion)) {
            int idProducto = Integer.parseInt(request.getParameter("idProducto"));
            List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
            
            if (carrito != null) {
                carrito.removeIf(item -> item.getProducto().getId_producto() == idProducto);
                session.setAttribute("carrito", carrito);
                
                // Actualizar contador y total
                int totalItems = 0;
                BigDecimal total = BigDecimal.ZERO;
                for (CarritoItem item : carrito) {
                    totalItems += item.getCantidad();
                    total = total.add(item.getSubtotal());
                }
                session.setAttribute("carritoContador", totalItems);
                session.setAttribute("carritoTotal", total);
                
                // SE ELIMINÓ EL MENSAJE DE SESIÓN "Producto eliminado"
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/carrito");
    }
}