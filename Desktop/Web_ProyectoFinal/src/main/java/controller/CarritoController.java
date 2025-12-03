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
        
        HttpSession session = request.getSession();
        List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
        
        BigDecimal total = BigDecimal.ZERO;
        if (carrito != null) {
            for (CarritoItem item : carrito) {
                total = total.add(item.getSubtotal());
            }
        }
        
        request.setAttribute("carritoTotal", total);
        request.getRequestDispatcher("/carrito.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String accion = request.getParameter("accion");
        List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
        
        if (carrito != null && accion != null) {
            try {
                int idProducto = Integer.parseInt(request.getParameter("idProducto"));
                
                // Buscar el item
                CarritoItem itemSeleccionado = null;
                for (CarritoItem item : carrito) {
                    if (item.getProducto().getId_producto() == idProducto) {
                        itemSeleccionado = item;
                        break;
                    }
                }

                if (itemSeleccionado != null) {
                    if ("eliminar".equals(accion)) {
                        carrito.remove(itemSeleccionado);
                    } else if ("aumentar".equals(accion)) {
                        // Validar stock antes de aumentar
                        if (itemSeleccionado.getCantidad() < itemSeleccionado.getProducto().getStock()) {
                            itemSeleccionado.setCantidad(itemSeleccionado.getCantidad() + 1);
                        } else {
                            session.setAttribute("error", "No hay más stock disponible para " + itemSeleccionado.getProducto().getNombre());
                        }
                    } else if ("disminuir".equals(accion)) {
                        if (itemSeleccionado.getCantidad() > 1) {
                            itemSeleccionado.setCantidad(itemSeleccionado.getCantidad() - 1);
                        }
                    }
                }

                session.setAttribute("carrito", carrito);
                
                // Recalcular contador total
                int totalItems = 0;
                for (CarritoItem item : carrito) {
                    totalItems += item.getCantidad();
                }
                session.setAttribute("carritoContador", totalItems);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/carrito");
    }
}