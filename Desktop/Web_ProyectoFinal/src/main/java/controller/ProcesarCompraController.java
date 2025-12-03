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
        
        String totalStr = (session != null) ? (String) session.getAttribute("carritoTotalStr") : null; 
        BigDecimal total;

        try {
            if (totalStr == null) throw new IllegalArgumentException("Total no encontrado.");
            total = new BigDecimal(totalStr);
        } catch (Exception e) {
            session.setAttribute("error", "Error: No se pudo calcular el total. Intente de nuevo.");
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
        
        // Validación básica de dirección
        if (direccionEnvio == null || direccionEnvio.trim().isEmpty()) {
            direccionEnvio = usuario.getDireccion(); 
            if (direccionEnvio == null || direccionEnvio.trim().isEmpty()) {
                direccionEnvio = "Dirección no especificada";
            }
        }

        Pedido pedido = new Pedido();
        pedido.setId_usuario(usuario.getId_usuario());
        pedido.setTotal(total);
        
        // --- ASIGNACIÓN DE ESTADOS ---
        // Asegúrate de haber ejecutado el SQL para que la BD acepte estos textos
        if ("yape".equals(metodoPago)) {
            pedido.setEstado("esperando pago");
        } else if ("contraentrega".equals(metodoPago)) {
            pedido.setEstado("por pagar");
        } else {
            // Tarjeta
            pedido.setEstado("pagado");
        }
        
        // Intentar crear el pedido
        boolean exito = pedidoDAO.crearPedido(pedido, carrito, direccionEnvio, metodoPago);
        
        if (exito) {
            // Limpiar carrito tras éxito
            session.removeAttribute("carrito");
            session.removeAttribute("carritoContador");
            session.removeAttribute("carritoTotalStr"); 
            
            session.setAttribute("mensaje", "¡Compra Exitosa! Pedido #" + pedido.getId_pedido() + " registrado (" + pedido.getEstado() + ").");
            response.sendRedirect(request.getContextPath() + "/mis-pedidos");
        } else {
            // Si falla, es probable que la BD rechace el texto o falte stock
            session.setAttribute("error", "Error al procesar. Verifique que la Base de Datos acepte los nuevos estados o revise el stock.");
            response.sendRedirect(request.getContextPath() + "/carrito");
        }
    }
}