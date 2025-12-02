package controller;

import dao.UsuarioDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder; // Importar para codificar la URL
import java.nio.charset.StandardCharsets; // Importar para especificar UTF-8

@WebServlet(name = "RegistroController", urlPatterns = {"/registro"})
public class RegistroController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");

        if (usuarioDAO.verificarCorreoExistente(correo)) {
            request.setAttribute("error", "El correo ya está registrado.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(request.getParameter("nombre"));
        nuevoUsuario.setApellido(request.getParameter("apellido"));
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setContrasena(request.getParameter("contrasena"));
        nuevoUsuario.setTelefono(request.getParameter("celular"));
        nuevoUsuario.setDireccion(request.getParameter("direccion"));

        if (usuarioDAO.registrar(nuevoUsuario)) {
            
            // --- INICIO: CORRECCIÓN ---
            // Usamos sendRedirect en lugar de forward para seguir el patrón Post-Redirect-Get.
            // Codificamos el mensaje para que los caracteres especiales (como 'é') no den error.
            String mensaje = "Usuario registrado. Ahora puede iniciar sesión.";
            String mensajeCodificado = URLEncoder.encode(mensaje, StandardCharsets.UTF_8.toString());

            // Redirigimos a la página de login con el mensaje en la URL.
            response.sendRedirect(request.getContextPath() + "/index.jsp?mensaje=" + mensajeCodificado);
            // --- FIN: CORRECCIÓN ---

        } else {
            request.setAttribute("error", "Error en la base de datos. No se pudo registrar.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}