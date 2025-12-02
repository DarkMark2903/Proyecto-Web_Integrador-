package controller;

import dao.UsuarioDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/agregarFavorito")
public class AgregarFavoritoController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // 1. Verificar si el usuario está logueado
        if (session == null || session.getAttribute("usuario") == null) {
            session.setAttribute("error", "Debes iniciar sesión para agregar productos a favoritos.");
            response.sendRedirect(request.getContextPath() + "/index.jsp"); // Redirigir al login
            return;
        }

        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        
        // 2. Obtener el ID del producto
        String idProductoStr = request.getParameter("idProducto");
        int idProducto = 0;
        
        try {
            idProducto = Integer.parseInt(idProductoStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Error: ID de producto inválido.");
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }
        
        // 3. Llamar al DAO para agregar el favorito
        boolean agregado = usuarioDAO.agregarFavorito(usuarioLogueado.getId_usuario(), idProducto);
        
        // 4. Establecer mensaje y redirigir al catálogo
        if (agregado) {
            session.setAttribute("mensaje", "Producto agregado a tus favoritos.");
        } else {
            session.setAttribute("error", "El producto ya se encuentra en tus favoritos.");
        }
        
        // Redirigir al catálogo para que se muestre el mensaje
        response.sendRedirect(request.getContextPath() + "/catalogo");
    }
}