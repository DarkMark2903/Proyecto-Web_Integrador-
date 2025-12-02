package controller;

import model.CarritoItem;
import model.Usuario;
import model.Tarjeta;
import dao.TarjetaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Collections;

@WebServlet("/carrito")
public class CarritoController extends HttpServlet {

    private final TarjetaDAO tarjetaDAO = new TarjetaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        List<CarritoItem> carrito = null;
        List<Tarjeta> listaTarjetas = Collections.emptyList();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        
        BigDecimal carritoTotal = BigDecimal.ZERO;

        if (session != null) {
            carrito = (List<CarritoItem>) session.getAttribute("carrito");
            
            if (carrito != null) {
                for (CarritoItem item : carrito) {
                    carritoTotal = carritoTotal.add(item.getSubtotal());
                }
            }
            
            // LÓGICA DE CARGA DE TARJETAS PARA EL CHECKOUT
            if (usuarioLogueado != null) {
                listaTarjetas = tarjetaDAO.obtenerTarjetasPorUsuario(usuarioLogueado.getId_usuario());
            }
        }
        
        BigDecimal totalConEnvio = carritoTotal.add(new BigDecimal("15.00"));

        request.setAttribute("carrito", carrito);
        request.setAttribute("carritoTotal", carritoTotal);
        request.setAttribute("totalConEnvio", totalConEnvio);
        request.setAttribute("listaTarjetas", listaTarjetas); // CRÍTICO: Pasa las tarjetas al carrito.jsp
        
        session.setAttribute("carritoTotalStr", totalConEnvio.toString()); 
        
        request.getRequestDispatcher("/carrito.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();
        List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
        
        if (carrito == null) {
            response.sendRedirect(request.getContextPath() + "/carrito");
            return;
        }

        // FIX: Lógica para eliminar un ítem completo del carrito
        if ("eliminar".equals(accion)) {
            try {
                int idProducto = Integer.parseInt(request.getParameter("idProducto"));
                
                // Eliminar el ítem que coincida con el ID
                boolean eliminado = carrito.removeIf(item -> item.getProducto().getId_producto() == idProducto);
                
                if (eliminado) {
                    // Recalcular contador
                    int nuevoContador = carrito.stream().mapToInt(CarritoItem::getCantidad).sum();
                    session.setAttribute("carritoContador", nuevoContador);
                    session.setAttribute("mensaje", "Producto eliminado del carrito.");
                } else {
                    session.setAttribute("error", "Error: Producto no encontrado en el carrito.");
                }
                
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Error al procesar el ID del producto.");
            }
        }
        
        // Redirige al doGet para recargar la vista y el total
        response.sendRedirect(request.getContextPath() + "/carrito");
    }
}