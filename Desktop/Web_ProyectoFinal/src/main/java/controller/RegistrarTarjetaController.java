package controller;

import dao.TarjetaDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/registrarTarjeta") 
public class RegistrarTarjetaController extends HttpServlet {
    
    private final TarjetaDAO tarjetaDAO = new TarjetaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp"); 
            return;
        }

        // 1. Obtener datos del formulario
        String numeroTarjetaCompleto = request.getParameter("numeroTarjeta");
        String nombreTitular = request.getParameter("nombreTitular");
        String fechaExpiracion = request.getParameter("fechaExpiracion");
        String tipoTarjeta = request.getParameter("tipoTarjeta"); // ej: Visa/Mastercard
        
        // 2. Procesar datos (Obtener solo los últimos 4 dígitos)
        String ultimosDigitos = (numeroTarjetaCompleto != null && numeroTarjetaCompleto.length() >= 4)
                                ? numeroTarjetaCompleto.substring(numeroTarjetaCompleto.length() - 4)
                                : "XXXX";

        // 3. Registrar en el DAO
        boolean exito = tarjetaDAO.registrarTarjeta(
            usuario.getId_usuario(), 
            ultimosDigitos, 
            nombreTitular, 
            fechaExpiracion, 
            tipoTarjeta
        );
        
        if (exito) {
            session.setAttribute("mensaje", "Tarjeta terminada en ****" + ultimosDigitos + " registrada con éxito.");
        } else {
            session.setAttribute("error", "Error al registrar la tarjeta. Revise el formato o las dependencias.");
        }

        response.sendRedirect(request.getContextPath() + "/misTarjetas"); // Redirigir al controlador de mis tarjetas
    }
}