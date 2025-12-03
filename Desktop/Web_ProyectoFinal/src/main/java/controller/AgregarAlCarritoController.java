package controller;

import dao.ProductoDAO;
import model.CarritoItem;
import model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/agregarCarrito")
public class AgregarAlCarritoController extends HttpServlet {
    
    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (request.getParameter("idProducto") == null) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        int idProducto = Integer.parseInt(request.getParameter("idProducto"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        String origen = request.getParameter("origen"); // "catalogo", "detalle", "inicio"
        
        Producto producto = productoDAO.obtenerPorId(idProducto);
        
        if (producto != null) {
            List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
            if (carrito == null) {
                carrito = new ArrayList<>();
            }
            
            boolean encontrado = false;
            for (CarritoItem item : carrito) {
                if (item.getProducto().getId_producto() == idProducto) {
                    if (item.getCantidad() + cantidad <= producto.getStock()) {
                        item.setCantidad(item.getCantidad() + cantidad);
                    } else {
                        if ("detalle".equals(origen)) {
                            session.setAttribute("error", "No puedes añadir más. Stock disponible: " + producto.getStock());
                        }
                    }
                    encontrado = true;
                    break;
                }
            }
            
            if (!encontrado) {
                if (cantidad <= producto.getStock()) {
                    carrito.add(new CarritoItem(producto, cantidad));
                } else {
                     if ("detalle".equals(origen)) {
                        session.setAttribute("error", "Stock insuficiente.");
                     }
                }
            }
            
            session.setAttribute("carrito", carrito);
            int totalItems = 0;
            for (CarritoItem item : carrito) totalItems += item.getCantidad();
            session.setAttribute("carritoContador", totalItems);
        }
        
        // LÓGICA DE REDIRECCIÓN
        if ("detalle".equals(origen)) {
            response.sendRedirect(request.getContextPath() + "/detalle_producto?id=" + idProducto);
        } else if ("inicio".equals(origen)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
        } else {
            response.sendRedirect(request.getContextPath() + "/catalogo");
        }
    }
}