package controller;

import model.CarritoItem;
import model.Pedido;
import model.Usuario;
import dao.PedidoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/procesarCompra")
public class ProcesarCompraController extends HttpServlet {
    
    private final PedidoDAO pedidoDAO = new PedidoDAO(); 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        List<CarritoItem> carrito = (session != null) ? (List<CarritoItem>) session.getAttribute("carrito") : null;
        
        // Recuperamos el total YA CALCULADO (con IGV y envío) desde la sesión
        String totalStr = (session != null) ? (String) session.getAttribute("carritoTotalStr") : null; 
        BigDecimal total;

        try {
            if (totalStr == null) throw new IllegalArgumentException("Total no encontrado.");
            total = new BigDecimal(totalStr);
        } catch (Exception e) {
            session.setAttribute("error", "Error en el total de la compra.");
            response.sendRedirect(request.getContextPath() + "/carrito");
            return;
        }
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        if (carrito == null || carrito.isEmpty()) {
            session.setAttribute("error", "El carrito está vacío.");
            response.sendRedirect(request.getContextPath() + "/carrito");
            return;
        }
        
        String metodoPago = request.getParameter("metodoPago"); 
        String direccionEnvio = request.getParameter("direccionEnvio");
        
        if (direccionEnvio == null || direccionEnvio.trim().isEmpty()) {
            direccionEnvio = usuario.getDireccion(); 
            if (direccionEnvio == null) direccionEnvio = "Dirección no especificada";
        }

        Pedido pedido = new Pedido();
        pedido.setId_usuario(usuario.getId_usuario());
        pedido.setTotal(total); // Este total ya incluye IGV + Envío
        
        boolean exito = pedidoDAO.crearPedido(pedido, carrito, direccionEnvio, metodoPago);
        
        if (exito) {
            session.removeAttribute("carrito");
            session.removeAttribute("carritoContador");
            session.removeAttribute("carritoTotalStr"); 
            
            session.setAttribute("mensaje", "¡Compra Exitosa! Pedido #" + pedido.getId_pedido() + " registrado.");
            response.sendRedirect(request.getContextPath() + "/mis-pedidos");
        } else {
            session.setAttribute("error", "Error al procesar la compra. Verifique el stock o intente nuevamente.");
            response.sendRedirect(request.getContextPath() + "/carrito");
        }
    }
}