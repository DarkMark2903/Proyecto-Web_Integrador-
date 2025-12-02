package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/image-server")
public class ImageServer extends HttpServlet {

    // Nombre de la carpeta donde se almacenan las imágenes subidas.
    // **NOTA CRÍTICA:** ESTA RUTA DEBE COINCIDIR CON LA RUTA DONDE LAS ALMACENAS AL SUBIRLAS.
    private static final String IMAGE_DIRECTORY = "uploads"; 
    
    // Tamaño del buffer para la transmisión de datos (puede ser ajustado)
    private static final int DEFAULT_BUFFER_SIZE = 10240; // 10KB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener el nombre del archivo de la URL
        String filename = request.getParameter("file");

        if (filename == null || filename.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404
            return;
        }

        // 2. Construir la ruta absoluta del archivo en el servidor
        // Usamos getServletContext().getRealPath() para obtener la ruta dentro de la aplicación.
        // Si las imágenes están fuera del proyecto, se necesita una ruta fija (ej: "C:/imagenes_tienda/").
        File imageFile = new File(getServletContext().getRealPath(IMAGE_DIRECTORY), filename);

        // 3. Verificar si el archivo existe
        if (!imageFile.exists() || imageFile.isDirectory()) {
            // Manejar caso donde no se encuentra la imagen.
            // Si quieres mostrar una imagen por defecto, puedes servirla aquí.
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404
            return;
        }

        // 4. Determinar el tipo de contenido (MIME type)
        String contentType = getServletContext().getMimeType(imageFile.getName());
        if (contentType == null) {
            // Si no se puede determinar el tipo, usar un valor genérico
            contentType = "application/octet-stream";
        }
        
        // 5. Configurar el response
        response.reset(); // Limpiar cualquier buffer o header previo
        response.setBufferSize(DEFAULT_BUFFER_SIZE);
        response.setContentType(contentType);
        response.setHeader("Content-Length", String.valueOf(imageFile.length()));
        response.setHeader("Content-Disposition", "inline; filename=\"" + imageFile.getName() + "\"");

        // 6. Escribir el contenido del archivo al response
        try (FileInputStream input = new FileInputStream(imageFile);
             OutputStream output = response.getOutputStream()) {

            byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
        }
    }
}