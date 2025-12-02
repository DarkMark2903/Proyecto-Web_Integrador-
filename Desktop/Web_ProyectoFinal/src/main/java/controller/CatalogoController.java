package controller;

import dao.CategoriaDAO;
import dao.ProductoDAO;
import dao.UsuarioDAO; // Importar UsuarioDAO para favoritos
import model.Categoria;
import model.Producto;
import model.Usuario; // Importar Usuario
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebServlet("/catalogo")
public class CatalogoController extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO(); // Instancia para favoritos

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener parámetros de filtro (si existen)
        String busqueda = request.getParameter("busqueda");
        String orden = request.getParameter("orden");
        int idCategoria = 0;

        // **Normalización de parámetros.**
        if (busqueda != null && busqueda.trim().isEmpty()) {
            busqueda = null;
        }
        if (orden != null && orden.trim().isEmpty()) {
            orden = null;
        }

        try {
            if (request.getParameter("categoria") != null) { 
                idCategoria = Integer.parseInt(request.getParameter("categoria"));
            }
        } catch (NumberFormatException e) {
            idCategoria = 0;
        }

        // 2. Obtener productos usando el método de filtrado del DAO
        List<Producto> listaProductos = productoDAO.listarConFiltros(busqueda, idCategoria, orden);
        
        // 3. Obtener categorías para el menú lateral
        List<Categoria> listaCategorias = categoriaDAO.obtenerTodas();
        
        // **********************************************
        // ******* LÓGICA DE FAVORITOS ******************
        // **********************************************
        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = null;
        
        if (session != null) {
            usuarioLogueado = (Usuario) session.getAttribute("usuario");
        }

        if (usuarioLogueado != null) {
            // Cargar los IDs de productos favoritos para este usuario
            // Este método debe existir en tu UsuarioDAO.java
            Set<Integer> favoritoIds = usuarioDAO.obtenerIdsFavoritosPorUsuario(usuarioLogueado.getId_usuario());
            request.setAttribute("favoritoIds", favoritoIds); 
        }
        // **********************************************

        // 4. Enviar datos al JSP
        request.setAttribute("productos", listaProductos);
        request.setAttribute("categorias", listaCategorias);
        
        request.setAttribute("busquedaActual", busqueda);
        request.setAttribute("categoriaActual", idCategoria);
        request.setAttribute("ordenActual", orden);

        request.getRequestDispatcher("/catalogo.jsp").forward(request, response);
    }
}