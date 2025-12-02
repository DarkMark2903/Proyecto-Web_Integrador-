package controller;

import dao.UsuarioDAO;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {
    
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        // --- LA CORRECCIÓN ESTÁ AQUÍ ---
        // Ahora busca "contrasena" para que coincida con el name="" del JSP.
        String contrasena = request.getParameter("contrasena"); 

        Usuario usuario = usuarioDAO.validar(correo, contrasena);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            String recordar = request.getParameter("recordar");
            if ("on".equals(recordar)) {
                Cookie cookie = new Cookie("correoRecordado", correo);
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 días
                response.addCookie(cookie);
            } else {
                Cookie cookie = new Cookie("correoRecordado", "");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }

            String rol = usuario.getRol();
            if ("admin".equals(rol) || "empleado".equals(rol)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/mi-cuenta");
            }
        } else {
            request.setAttribute("error", "Correo o contraseña incorrectos");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}