package controller;

import dao.UsuarioDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/eliminarFavorito")
public class EliminarFavoritoController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String idProductoStr = request.getParameter("idProducto");
        
        if (idProductoStr != null) {
            try {
                int idProducto = Integer.parseInt(idProductoStr);
                if (usuarioDAO.eliminarFavorito(usuario.getId_usuario(), idProducto)) {
                    session.setAttribute("mensaje", "Producto eliminado de tus favoritos.");
                } else {
                    session.setAttribute("error", "No se pudo eliminar el favorito.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID de producto inválido.");
            }
        }
        
        // REDIRECCIÓN A LA VISTA DE MIS FAVORITOS PARA VER LA NOTIFICACIÓN
        response.sendRedirect(request.getContextPath() + "/misFavoritos");
    }
}