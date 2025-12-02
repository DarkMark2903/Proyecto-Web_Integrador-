package controller;

import dao.UsuarioDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder; // Importar la clase de codificación
import java.nio.charset.StandardCharsets; // Para especificar UTF-8

@WebServlet("/eliminar-cuenta")
public class EliminarCuentaController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. Verificar si hay sesión activa
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        Usuario user = (Usuario) session.getAttribute("usuario");
        
        // 2. Ejecutar la desactivación del usuario en la BD
        if (usuarioDAO.eliminarUsuario(user.getId_usuario())) {
            
            // 3. Éxito: Invalidar la sesión
            session.invalidate();
            
            // **PASO CLAVE: CODIFICAR el mensaje antes de enviarlo en la URL.**
            String mensaje = "Tu cuenta ha sido eliminada con éxito.";
            String mensajeCodificado = URLEncoder.encode(mensaje, StandardCharsets.UTF_8.toString());

            // Redirigir al login con el mensaje codificado
            response.sendRedirect(request.getContextPath() + "/index.jsp?mensaje=" + mensajeCodificado);
            
        } else {
            // 4. Fallo: Redirigir a la vista de cuenta con mensaje de error
            session.setAttribute("error", "Error interno al procesar la eliminación de tu cuenta. Inténtalo de nuevo.");
            response.sendRedirect(request.getContextPath() + "/mi-cuenta");
        }
    }
}