package controller;

import dao.UsuarioDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

// La ruta "/editarInfo" es la que busca el formulario
@WebServlet("/editarInfo")
public class EditarInfoController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        request.getRequestDispatcher("/cliente/editar_info.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Usuario actual de la sesión
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        
        // 1. Recoger datos del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String nuevaContrasena = request.getParameter("nuevaContrasena");

        // 2. Crear objeto para actualización
        Usuario usuarioAActualizar = new Usuario();
        usuarioAActualizar.setId_usuario(usuarioSesion.getId_usuario());
        usuarioAActualizar.setNombre(nombre);
        usuarioAActualizar.setApellido(apellido);
        usuarioAActualizar.setTelefono(telefono);
        usuarioAActualizar.setDireccion(direccion);
        // El correo no se actualiza por seguridad/lógica de negocio
        
        // 3. Llamar al DAO
        boolean exito = usuarioDAO.actualizarUsuario(usuarioAActualizar, nuevaContrasena);

        if (exito) {
            // 4. Actualizar la sesión con los nuevos datos para que se vean reflejados al instante
            usuarioSesion.setNombre(nombre);
            usuarioSesion.setApellido(apellido);
            usuarioSesion.setTelefono(telefono);
            usuarioSesion.setDireccion(direccion);
            // No guardamos la contraseña en sesión
            
            session.setAttribute("usuario", usuarioSesion);
            session.setAttribute("mensaje", "Información actualizada correctamente.");
            
            // Redirigir a la cuenta
            response.sendRedirect(request.getContextPath() + "/cliente/cuenta.jsp"); 
            
        } else {
            // 5. Error
            request.setAttribute("error", "Error al guardar los cambios en la base de datos.");
            request.getRequestDispatcher("/cliente/editar_info.jsp").forward(request, response);
        }
    }
}