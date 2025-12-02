package controller;

import dao.CategoriaDAO;
import dao.ProductoDAO;
import model.Producto;
import model.Categoria;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID; 

@WebServlet("/admin/gestionar-productos")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10,      
                 maxRequestSize = 1024 * 1024 * 50)  
public class GestionarProductosController extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    
    private static final String UPLOAD_DIRECTORY = "img"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Producto> listaProductos = productoDAO.obtenerTodos(); 
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
                // --- LÓGICA DE CREACIÓN ---
                crearProducto(request, session);
                
            } else if ("update".equals(action)) {
                // --- LÓGICA DE ACTUALIZACIÓN (CORREGIDA) ---
                actualizarProducto(request, session);
                
            } else {
                // --- LÓGICA DE ESTADO / ELIMINAR ---
                // Aquí usamos "idProducto" porque el formulario de la tabla usa ese nombre
                String idProductoStr = request.getParameter("idProducto");
                int idProducto = Integer.parseInt(idProductoStr);
                
                Producto productoActual = productoDAO.obtenerPorId(idProducto);
                
                if (productoActual != null) {
                    if ("toggle_status".equals(action)) {
                        String nuevoEstado = productoActual.getEstado().equals("activo") ? "inactivo" : "activo";
                        if (productoDAO.cambiarEstadoProducto(idProducto, nuevoEstado)) { 
                            session.setAttribute("mensaje", "Estado actualizado correctamente.");
                        } else {
                            session.setAttribute("error", "Error al cambiar estado.");
                        }
                    } else if ("delete".equals(action)) {
                        if (productoActual.getEstado().equals("inactivo")) {
                            if (productoDAO.eliminarProductoFisico(idProducto)) {
                                session.setAttribute("mensaje", "Producto eliminado.");
                            } else {
                                session.setAttribute("error", "Error al eliminar (posibles dependencias).");
                            }
                        } else {
                             session.setAttribute("error", "El producto debe estar inactivo para eliminarlo.");
                        }
                    }
                } else {
                    session.setAttribute("error", "Producto no encontrado.");
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error procesando la solicitud: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/gestionar-productos");
    }

    private void crearProducto(HttpServletRequest request, HttpSession session) throws Exception {
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        BigDecimal precio = new BigDecimal(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        
        String fileName = subirImagen(request.getPart("imagen"));
        if (fileName == null) fileName = "default.png";

        Producto p = new Producto();
        p.setNombre(nombre);
        p.setDescripcion(descripcion);
        p.setPrecio(precio);
        p.setStock(stock);
        p.setId_categoria(idCategoria);
        p.setImagen(fileName); 
        
        if (productoDAO.crearProducto(p)) {
            session.setAttribute("mensaje", "Producto creado con éxito.");
        } else {
            session.setAttribute("error", "Error al crear producto.");
        }
    }

    private void actualizarProducto(HttpServletRequest request, HttpSession session) throws Exception {
        // Usamos idProductoUpdate como en el modal de edición
        int idProducto = Integer.parseInt(request.getParameter("idProductoUpdate"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        BigDecimal precio = new BigDecimal(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        
        // Obtener producto actual para mantener la imagen si no se sube una nueva
        Producto pActual = productoDAO.obtenerPorId(idProducto);
        
        String fileName = subirImagen(request.getPart("imagen"));
        if (fileName == null) {
            fileName = pActual.getImagen(); // Mantener imagen anterior
        }

        Producto p = new Producto();
        p.setId_producto(idProducto);
        p.setNombre(nombre);
        p.setDescripcion(descripcion);
        p.setPrecio(precio);
        p.setStock(stock);
        p.setId_categoria(idCategoria);
        p.setImagen(fileName);
        
        if (productoDAO.actualizarProducto(p)) {
            session.setAttribute("mensaje", "Producto actualizado con éxito.");
        } else {
            session.setAttribute("error", "Error al actualizar producto.");
        }
    }

    private String subirImagen(Part filePart) throws IOException {
        if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = "";
            int i = submittedFileName.lastIndexOf('.');
            if (i > 0) extension = submittedFileName.substring(i);
            
            String fileName = UUID.randomUUID().toString() + extension;
            
            // Ruta real en el servidor (target/...)
            String applicationPath = getServletContext().getRealPath("");
            Path uploadPath = Paths.get(applicationPath, UPLOAD_DIRECTORY);

            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            }
            return fileName;
        }
        return null;
    }
}