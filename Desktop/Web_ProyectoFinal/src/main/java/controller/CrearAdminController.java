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

@WebServlet("/admin/crear-admin")
public class CrearAdminController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        
        // 1. Validar Súper Admin
        if (usuarioLogueado == null || !usuarioLogueado.getCorreo().equals("admin@peruvianstyle.com")) {
            session.setAttribute("error", "Acceso denegado. Solo el Súper Administrador puede crear nuevas cuentas de administrador.");
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-admins");
            return;
        }

        // 2. Recolección y mapeo de datos del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String telefono = request.getParameter("telefono");
        String rol = request.getParameter("rol"); // Debería ser 'admin' o 'empleado'
        
        if (nombre == null || correo == null || contrasena == null) {
            session.setAttribute("error", "Faltan campos obligatorios para crear el administrador.");
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-admins");
            return;
        }
        
        // 3. Crear objeto Usuario
        Usuario nuevoAdmin = new Usuario();
        nuevoAdmin.setNombre(nombre);
        nuevoAdmin.setApellido(apellido);
        nuevoAdmin.setCorreo(correo);
        nuevoAdmin.setContrasena(contrasena); // Nota: En producción, usa hash
        nuevoAdmin.setTelefono(telefono);
        nuevoAdmin.setRol(rol);
        nuevoAdmin.setEstado("activo");

        // 4. Validar si el correo ya existe
        if (usuarioDAO.verificarCorreoExistente(correo)) {
            session.setAttribute("error", "El correo ya está registrado en el sistema.");
            response.sendRedirect(request.getContextPath() + "/admin/gestionar-admins");
            return;
        }

        // 5. Llamada al DAO para registrar
        boolean exito = usuarioDAO.registrar(nuevoAdmin); 
        
        if (exito) {
            session.setAttribute("mensaje", "Nueva cuenta de administrador (" + rol.toUpperCase() + ") creada con éxito.");
        } else {
            session.setAttribute("error", "Error al registrar la nueva cuenta administrativa.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/gestionar-admins");
    }
}