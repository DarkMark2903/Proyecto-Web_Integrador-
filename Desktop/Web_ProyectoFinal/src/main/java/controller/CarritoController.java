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
        
        // LÓGICA DE CÁLCULO AL ENTRAR AL CARRITO
        HttpSession session = request.getSession();
        List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
        
        BigDecimal total = BigDecimal.ZERO;
        if (carrito != null) {
            for (CarritoItem item : carrito) {
                total = total.add(item.getSubtotal());
            }
        }
        
        // Enviamos el total como atributo de request para que el JSP lo use en el cálculo
        request.setAttribute("carritoTotal", total);
        
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
                
                // Actualizar contador
                int totalItems = 0;
                for (CarritoItem item : carrito) {
                    totalItems += item.getCantidad();
                }
                session.setAttribute("carritoContador", totalItems);
                
                // No necesitamos calcular el total aquí para guardarlo en sesión si el doGet lo hace,
                // pero para mantener coherencia inmediata al redirigir, está bien que el doGet lo recalcule.
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/carrito");
    }
}