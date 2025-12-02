package controller;

import dao.ProductoDAO;
import model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DetalleProductoController", urlPatterns = {"/detalle_producto"})
public class DetalleProductoController extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int idProducto = 0;
        try {
            idProducto = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("catalogo");
            return;
        }

        Producto producto = productoDAO.obtenerPorId(idProducto);

        if (producto != null) {
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("/detalle_producto.jsp").forward(request, response);
        } else {
            response.sendRedirect("catalogo");
        }
    }
}