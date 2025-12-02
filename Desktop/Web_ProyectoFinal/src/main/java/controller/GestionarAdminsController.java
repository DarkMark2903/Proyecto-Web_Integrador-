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

@WebServlet("/admin/gestionar-admins")
public class GestionarAdminsController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lógica de autenticación (ya cubierta por el JSP, pero buena práctica)
        if (request.getSession().getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 1. Obtener la lista de usuarios con rol 'admin' y 'empleado'
        List<Usuario> listaUsuarios = usuarioDAO.obtenerTodosPorRol("admin");
        
        // 2. Pasar la lista al JSP
        request.setAttribute("listaUsuarios", listaUsuarios);
        
        // 3. Reenviar al JSP de la vista
        request.getRequestDispatcher("/administrador/gestionar_admins.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-admins");
            return;
        }
        
        boolean exito = false;
        
        if ("desactivar".equals(action)) {
            exito = usuarioDAO.desactivarUsuario(idUsuario);
            if (exito) {
                session.setAttribute("mensaje", "Administrador desactivado correctamente.");
            } else {
                session.setAttribute("error", "Error al desactivar administrador.");
            }
        } else if ("activar".equals(action)) {
            exito = usuarioDAO.activarUsuario(idUsuario);
            if (exito) {
                session.setAttribute("mensaje", "Administrador activado correctamente.");
            } else {
                session.setAttribute("error", "Error al activar administrador.");
            }
        } else if ("delete_permanent".equals(action)) {
            // Manejar la eliminación física (REQUIERE SER SÚPER ADMIN PARA ESTA ACCIÓN)
            Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
            if (usuarioLogueado == null || !usuarioLogueado.getCorreo().equals("admin@peruvianstyle.com")) {
                 session.setAttribute("error", "Acceso denegado. Solo el Súper Administrador puede eliminar cuentas permanentemente.");
            } else {
                exito = usuarioDAO.eliminarUsuarioFisico(idUsuario);
                if (exito) {
                    session.setAttribute("mensaje", "Administrador eliminado permanentemente.");
                } else {
                    session.setAttribute("error", "Error al eliminar permanentemente al administrador. Asegúrese de que no tenga registros dependientes.");
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/gestionar-admins");
    }
}