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
import java.util.List;

@WebServlet("/admin/gestionar-clientes")
public class GestionarClientesController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lógica de autenticación (ya cubierta por el JSP, pero buena práctica)
        if (request.getSession().getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 1. Obtener la lista de clientes (solo rol 'cliente')
        List<Usuario> listaUsuarios = usuarioDAO.obtenerTodosPorRol("cliente");
        
        // 2. Pasar la lista al JSP
        request.setAttribute("listaUsuarios", listaUsuarios);
        
        // 3. Reenviar al JSP de la vista
        request.getRequestDispatcher("/administrador/gestionar_clientes.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        int idUsuario = 0;
        HttpSession session = request.getSession();
        
        try {
            idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de usuario inválido.");
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-clientes");
            return;
        }
        
        boolean exito = false;
        
        if ("desactivar".equals(action)) {
            exito = usuarioDAO.desactivarUsuario(idUsuario);
            if (exito) {
                session.setAttribute("mensaje", "Cliente desactivado correctamente.");
            } else {
                session.setAttribute("error", "Error al desactivar cliente.");
            }
        } else if ("activar".equals(action)) {
            exito = usuarioDAO.activarUsuario(idUsuario);
            if (exito) {
                session.setAttribute("mensaje", "Cliente activado correctamente.");
            } else {
                session.setAttribute("error", "Error al activar cliente.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/gestionar-clientes");
    }
}