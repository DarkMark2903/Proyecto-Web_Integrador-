package controller;

import dao.CategoriaDAO;
import dao.ProductoDAO;
import model.Producto;
import model.Categoria;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/gestionar-productos")
public class GestionarProductosController extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Filtros
        String busqueda = request.getParameter("busqueda");
        String catStr = request.getParameter("categoria");
        String ordenStock = request.getParameter("ordenStock"); // Nuevo filtro

        int idCategoria = 0;
        if (catStr != null && !catStr.isEmpty()) {
            try { idCategoria = Integer.parseInt(catStr); } catch (NumberFormatException e) { }
        }

        // 2. Listar con filtros
        List<Producto> listaProductos = productoDAO.listarProductosAdmin(busqueda, idCategoria, ordenStock);
        
        List<Categoria> listaCategorias = categoriaDAO.obtenerTodas();
        
        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("listaCategorias", listaCategorias);
        
        request.getRequestDispatcher("/administrador/gestionar_productos.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        try {
            if ("create".equals(action)) {
                crearProducto(request, session);
            } else if ("update".equals(action)) {
                actualizarProducto(request, session);
            } else if ("create_category".equals(action)) {
                String nombre = request.getParameter("nombreCat");
                String descripcion = request.getParameter("descCat");
                if (categoriaDAO.crearCategoria(nombre, descripcion)) session.setAttribute("mensaje", "Categoría creada.");
                else session.setAttribute("error", "Error al crear categoría.");
            } else if ("update_category".equals(action)) { // EDITAR CATEGORÍA
                int id = Integer.parseInt(request.getParameter("idCategoria"));
                String nombre = request.getParameter("nombreCat");
                String descripcion = request.getParameter("descCat");
                if (categoriaDAO.actualizarCategoria(id, nombre, descripcion)) session.setAttribute("mensaje", "Categoría actualizada.");
                else session.setAttribute("error", "Error al actualizar categoría.");
            } else if ("delete_category".equals(action)) { // ELIMINAR CATEGORÍA
                int id = Integer.parseInt(request.getParameter("idCategoria"));
                if (categoriaDAO.eliminarCategoria(id)) session.setAttribute("mensaje", "Categoría eliminada.");
                else session.setAttribute("error", "No se puede eliminar la categoría (tiene productos asociados).");
            } else {
                procesarOtrasAcciones(action, request, session);
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/gestionar-productos");
    }

    private void crearProducto(HttpServletRequest request, HttpSession session) {
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        BigDecimal precio = new BigDecimal(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        String imagenUrl = request.getParameter("imagen");
        if (imagenUrl == null || imagenUrl.trim().isEmpty()) imagenUrl = "https://via.placeholder.com/300?text=Sin+Imagen";

        Producto p = new Producto();
        p.setNombre(nombre);
        p.setDescripcion(descripcion);
        p.setPrecio(precio);
        p.setStock(stock);
        p.setId_categoria(idCategoria);
        p.setImagen(imagenUrl);
        
        if (productoDAO.crearProducto(p)) session.setAttribute("mensaje", "Producto creado.");
        else session.setAttribute("error", "Error al crear producto.");
    }

    private void actualizarProducto(HttpServletRequest request, HttpSession session) {
        int idProducto = Integer.parseInt(request.getParameter("idProductoUpdate"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        BigDecimal precio = new BigDecimal(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        String imagenUrl = request.getParameter("imagen");
        
        if (imagenUrl == null || imagenUrl.trim().isEmpty()) {
            Producto pActual = productoDAO.obtenerPorId(idProducto);
            imagenUrl = pActual.getImagen();
        }

        Producto p = new Producto();
        p.setId_producto(idProducto);
        p.setNombre(nombre);
        p.setDescripcion(descripcion);
        p.setPrecio(precio);
        p.setStock(stock);
        p.setId_categoria(idCategoria);
        p.setImagen(imagenUrl);
        
        if (productoDAO.actualizarProducto(p)) session.setAttribute("mensaje", "Producto actualizado.");
        else session.setAttribute("error", "Error al actualizar.");
    }
    
    private void procesarOtrasAcciones(String action, HttpServletRequest request, HttpSession session) {
        String idProductoStr = request.getParameter("idProducto");
        if(idProductoStr == null) return;
        int idProducto = Integer.parseInt(idProductoStr);
        ProductoDAO pDAO = new ProductoDAO();
        
        if ("toggle_status".equals(action)) {
            Producto p = pDAO.obtenerPorId(idProducto);
            String nuevo = p.getEstado().equals("activo") ? "inactivo" : "activo";
            pDAO.cambiarEstadoProducto(idProducto, nuevo);
            session.setAttribute("mensaje", "Estado actualizado.");
        } else if ("delete".equals(action)) {
            try {
                if (pDAO.eliminarProductoFisico(idProducto)) {
                    session.setAttribute("mensaje", "Producto eliminado permanentemente.");
                } else {
                    pDAO.cambiarEstadoProducto(idProducto, "inactivo");
                    session.setAttribute("mensaje", "Producto desactivado (historial existente).");
                }
            } catch (Exception e) {
                pDAO.cambiarEstadoProducto(idProducto, "inactivo");
                session.setAttribute("mensaje", "Producto desactivado (error al eliminar).");
            }
        }
    }
}