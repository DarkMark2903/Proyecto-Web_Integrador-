<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer class="bg-dark text-white pt-5 pb-4 mt-5 border-top border-warning">
    <div class="container text-md-start">
        <div class="row text-center text-md-start">
            
            <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mb-4">
                <h5 class="text-uppercase fw-bold mb-4 text-warning">Peruvian&Style</h5>
                <p>
                    La tienda líder en moda y accesorios.
                    Ofreciendo calidad, estilo y elegancia en cada compra.
                </p>
            </div>

            <div class="col-md-2 col-lg-2 col-xl-2 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">Enlaces</h6>
                <p><a href="${pageContext.request.contextPath}/inicio.jsp" class="text-reset text-decoration-none footer-link">Inicio</a></p>
                <p><a href="${pageContext.request.contextPath}/catalogo.jsp" class="text-reset text-decoration-none footer-link">Catálogo</a></p>
                <p><a href="${pageContext.request.contextPath}/acerca.jsp" class="text-reset text-decoration-none footer-link">Acerca de Nosotros</a></p>
                <p><a href="${pageContext.request.contextPath}/contacto.jsp" class="text-reset text-decoration-none footer-link">Contacto</a></p>
                <p><a href="${pageContext.request.contextPath}/privacidad.jsp" class="text-reset text-decoration-none footer-link">Politicas de Privacidad</a></p>
                <p><a href="${pageContext.request.contextPath}/terminos.jsp" class="text-reset text-decoration-none footer-link">Términos y Condiciones</a></p>
                <p><a href="${pageContext.request.contextPath}/devoluciones.jsp" class="text-reset text-decoration-none footer-link">Devoluciones</a></p>
            </div>

            <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mb-md-0 mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">Contáctanos</h6>
                <p><i class="bi bi-geo-alt-fill me-3 text-warning"></i> Lima, Perú</p>
                <p><i class="bi bi-envelope-fill me-3 text-warning"></i> peruvianstyle@gmail.com</p>
                <p><i class="bi bi-telephone-fill me-3 text-warning"></i> 933 362 455</p>
                
                <div class="mt-3">
                    <a href="https://facebook.com" target="_blank" class="text-white me-3 fs-5 footer-icon"><i class="bi bi-facebook"></i></a>
                    <a href="https://instagram.com" target="_blank" class="text-white me-3 fs-5 footer-icon"><i class="bi bi-instagram"></i></a>
                    <a href="https://twitter.com" target="_blank" class="text-white me-3 fs-5 footer-icon"><i class="bi bi-twitter"></i></a>
                </div>
            </div>

            <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">Boletín</h6>
                <p>Suscríbete para recibir nuestras últimas ofertas.</p>
                <form id="formBoletin" onsubmit="mostrarModalBoletin(event)">
                    <div class="mb-2">
                        <input type="email" class="form-control bg-secondary border-0 text-white" placeholder="Tu correo" required>
                    </div>
                    <button type="submit" class="btn btn-warning w-100 fw-bold">Suscribirse</button>
                </form>
            </div>
        </div>
    </div>

    <div class="text-center p-3 text-white-50" style="background-color: rgba(0, 0, 0, 0.4);">
        © 2025 Copyright:
        <a class="text-warning text-decoration-none" href="#">Peruvian&Style.com</a>
    </div>
    
    <style>
        /* Estilos para hover en el footer */
        .footer-link:hover {
            color: #e0cd95 !important;
            text-decoration: underline !important;
        }
        .footer-icon:hover i {
            color: #e0cd95 !important;
        }
        .footer-icon i {
            transition: color 0.3s;
        }
        /* Animación para el modal del footer */
        .zoom-in-modal {
            animation: zoomIn 0.5s;
        }
        @keyframes zoomIn {
            from { opacity: 0; transform: scale(0.5); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>

    <div class="modal fade" id="modalBoletinSuccess" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content bg-white text-dark border-warning">
                <div class="modal-body text-center p-4">
                    <i class="bi bi-envelope-check-fill text-warning display-3 zoom-in-modal d-block mb-3"></i>
                    <h5 class="fw-bold mb-2">¡Suscrito!</h5>
                    <p class="small text-muted">Gracias por suscribirse a nuestro boletín.</p>
                    <button type="button" class="btn btn-dark btn-sm w-100" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function mostrarModalBoletin(event) {
            event.preventDefault(); // Evita recarga inmediata
            // Usamos Bootstrap ya cargado en la página principal
            const modalBoletin = new bootstrap.Modal(document.getElementById('modalBoletinSuccess'));
            modalBoletin.show();
            
            // Limpiar campo
            document.getElementById('formBoletin').reset();
        }
    </script>
</footer>