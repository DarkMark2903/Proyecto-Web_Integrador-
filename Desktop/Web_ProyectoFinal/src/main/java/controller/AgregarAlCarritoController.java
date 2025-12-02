package controller;

import model.CarritoItem;
import model.Producto;
import model.Usuario; 
import dao.ProductoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/agregarCarrito")
public class AgregarAlCarritoController extends HttpServlet {
    
    private final ProductoDAO productoDAO = new ProductoDAO(); 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        
        String referer = request.getHeader("referer");
        if (referer == null || referer.isEmpty()) {
            referer = request.getContextPath() + "/catalogo";
        }

        // 1. Restricción para usuario no logueado
        if (usuarioLogueado == null) {
            if (session == null) session = request.getSession(true);
            session.setAttribute("error", "Debe iniciar sesión para agregar productos al carrito.");
            response.sendRedirect(referer); 
            return;
        }
        
        // 2. Obtener parámetros y validar
        int idProducto;
        int cantidad;
        
        try {
            idProducto = Integer.parseInt(request.getParameter("idProducto"));
            // Lee la cantidad que viene del formulario de detalle (o 1 del catálogo)
            String cantidadStr = request.getParameter("cantidad");
            cantidad = Integer.parseInt(cantidadStr != null && !cantidadStr.isEmpty() ? cantidadStr : "1"); 
            
            // FIX CRÍTICO: Validación Server-Side del límite de 10
            if (cantidad <= 0 || cantidad > 10) { 
                request.getSession().setAttribute("error", "La cantidad debe ser entre 1 y 10.");
                response.sendRedirect(referer);
                return;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Cantidad inválida.");
            response.sendRedirect(referer);
            return;
        }

        // 3. Obtener el producto completo de la DB
        Producto producto = productoDAO.obtenerPorId(idProducto);
        if (producto == null) {
            request.getSession().setAttribute("error", "Producto no encontrado.");
            response.sendRedirect(referer);
            return;
        }
        
        // 4. Lógica de adición/actualización del carrito
        List<CarritoItem> carrito;
        if (session.getAttribute("carrito") == null) {
            carrito = new ArrayList<>();
        } else {
            carrito = (List<CarritoItem>) session.getAttribute("carrito");
        }

        boolean encontrado = false;
        for (CarritoItem item : carrito) {
            if (item.getProducto().getId_producto() == idProducto) {
                // Validación para evitar que la suma exceda el stock o el límite de 10
                int nuevaCantidadTotal = item.getCantidad() + cantidad;
                
                if (nuevaCantidadTotal > producto.getStock()) {
                    session.setAttribute("error", "No puedes añadir más. Stock disponible: " + producto.getStock());
                    response.sendRedirect(referer);
                    return;
                }
                if (nuevaCantidadTotal > 10) {
                     session.setAttribute("error", "Límite de 10 unidades por producto alcanzado.");
                    response.sendRedirect(referer);
                    return;
                }
                item.setCantidad(nuevaCantidadTotal);
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            // Validar stock antes de añadir nuevo item
            if (cantidad > producto.getStock()) {
                session.setAttribute("error", "Stock insuficiente.");
                response.sendRedirect(referer);
                return;
            }
            CarritoItem nuevoItem = new CarritoItem(producto, cantidad);
            carrito.add(nuevoItem);
        }

        // 5. Actualizar la sesión y redirigir
        session.setAttribute("carrito", carrito);
        int nuevoContador = carrito.stream().mapToInt(CarritoItem::getCantidad).sum();
        session.setAttribute("carritoContador", nuevoContador);
        
        session.setAttribute("mensaje", "Producto '" + producto.getNombre() + "' agregado al carrito.");
        response.sendRedirect(referer); 
    }
}