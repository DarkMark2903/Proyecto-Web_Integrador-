package controller;

import dao.TarjetaDAO;
import model.Usuario;
import model.Tarjeta; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/misTarjetas") 
public class MisTarjetasController extends HttpServlet {

    private final TarjetaDAO tarjetaDAO = new TarjetaDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        
        // 1. Validar Sesión
        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp"); 
            return;
        }

        List<Tarjeta> listaTarjetas;
        
        try {
            // 2. Obtener la lista de tarjetas (Persistencia Fix)
            listaTarjetas = tarjetaDAO.obtenerTarjetasPorUsuario(usuarioLogueado.getId_usuario());
        } catch (Exception e) {
            System.err.println("Error al obtener tarjetas: " + e.getMessage());
            listaTarjetas = Collections.emptyList(); 
            request.getSession().setAttribute("error", "Error al cargar los métodos de pago.");
        }
        
        // 3. Pasar la lista al JSP
        request.setAttribute("listaTarjetas", listaTarjetas);
        
        request.getRequestDispatcher("/cliente/mis_tarjetas.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        
        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp"); 
            return;
        }

        String idTarjetaStr = request.getParameter("idTarjeta");
        int idTarjeta;
        
        try {
            idTarjeta = Integer.parseInt(idTarjetaStr);
            
            // 1. Ejecutar eliminación
            if (tarjetaDAO.eliminarTarjeta(idTarjeta, usuarioLogueado.getId_usuario())) {
                session.setAttribute("mensaje", "Tarjeta eliminada con éxito.");
            } else {
                session.setAttribute("error", "Error al eliminar la tarjeta o ID no válido.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de tarjeta inválido.");
        }
        
        response.sendRedirect(request.getContextPath() + "/misTarjetas"); 
    }
}