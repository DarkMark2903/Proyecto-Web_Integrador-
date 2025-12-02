package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cerrarSesion")
public class CerrarSesion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtener la sesión actual (sin crear una nueva si no existe)
        HttpSession session = request.getSession(false); 

        // 2. Si la sesión existe, invalidarla (destruirla)
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirigir al usuario a la página de inicio
        response.sendRedirect(request.getContextPath() + "/inicio.jsp");
    }
}