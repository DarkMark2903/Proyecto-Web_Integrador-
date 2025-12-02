package controller;

import dao.UsuarioDAO;
import model.Usuario;
import model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

// FIX: Usamos un mapeo limpio (/misFavoritos) para evitar el bucle de recursión.
@WebServlet("/misFavoritos") 
public class MisFavoritosController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO(); // Asegúrate de tener el import correcto

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = null;
        
        if (session != null) {
            usuarioLogueado = (Usuario) session.getAttribute("usuario");
        }

        // 1. Validar Sesión (Si no está logueado, redirigir al login)
        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp"); 
            return;
        }

        // 2. Obtener la lista de productos favoritos (LÓGICA AGREGADA)
        // Se asume que UsuarioDAO ya tiene el método obtenerProductosFavoritosPorUsuario
        List<Producto> listaFavoritos = usuarioDAO.obtenerProductosFavoritosPorUsuario(usuarioLogueado.getId_usuario());
        
        // 3. Enviar la lista al JSP
        request.setAttribute("favoritos", listaFavoritos);
        
        // 4. Reenviar al JSP correcto
        request.getRequestDispatcher("/cliente/mis_favoritos.jsp").forward(request, response);
    }
}