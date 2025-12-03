<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Contacto - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        .content-container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 0 15px;
        }
        h1 {
            color: #e0cd95; /* Dorado */
            font-weight: 700;
            margin-bottom: 40px;
            text-align: center;
        }
        .contact-card {
            background-color: #f8f9fa; /* Gris claro */
            border-radius: 12px;
            border: 1px solid #e0cd95;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            height: 100%; /* Asegura que ambas tarjetas tengan la misma altura */
        }
        .contact-card h5, .contact-card h6 {
            color: #e0cd95; /* Dorado */
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-custom {
            background-color: #e0cd95;
            border: none;
            font-weight: bold;
            border-radius: 8px;
            padding: 10px 25px;
            transition: background-color 0.3s;
        }
        .btn-custom:hover {
            background-color: #cbb678; /* Dorado más oscuro */
            color: #fff;
        }
        .contact-card p i {
            color: #e0cd95; /* Iconos dorados */
        }
        .contact-card a i {
            color: #333; /* Iconos de redes sociales oscuros */
            transition: color 0.3s;
        }
        .contact-card a:hover i {
            color: #e0cd95; /* Hover dorado en redes sociales */
        }

        /* Animación para el Modal */
        .bounce-in {
            animation: bounce 0.6s;
        }
        @keyframes bounce {
            0% { transform: scale(0); opacity: 0; }
            50% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <jsp:include page="/header/header.jsp" />

    <div class="content-container">
        <h1>Contáctanos</h1>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="contact-card">
                    <h5>Formulario de Contacto</h5>
                    <form id="formContacto" onsubmit="mostrarModalContacto(event)">
                        <div class="mb-3">
                            <label for="nombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="nombre" placeholder="Tu nombre" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Correo electrónico</label>
                            <input type="email" class="form-control" id="email" placeholder="Tu correo" required>
                        </div>
                        <div class="mb-3">
                            <label for="telefono" class="form-label">Teléfono (Opcional)</label>
                            <input type="text" class="form-control" id="telefono" placeholder="Tu teléfono">
                        </div>
                        <div class="mb-3">
                            <label for="asunto" class="form-label">Asunto</label>
                            <input type="text" class="form-control" id="asunto" placeholder="Motivo de tu mensaje" required>
                        </div>
                        <div class="mb-3">
                            <label for="mensaje" class="form-label">Mensaje</label>
                            <textarea class="form-control" id="mensaje" rows="4" placeholder="Escribe tu mensaje" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-custom w-100">Enviar Mensaje</button>
                    </form>
                </div>
            </div>

            <div class="col-md-6">
                <div class="contact-card">
                    <h5>Información de Contacto</h5>
                    <p><i class="bi bi-envelope-fill me-2"></i>peruvianstyle@gmail.com</p>
                    <p><i class="bi bi-telephone-fill me-2"></i>+51 933 362 455</p>
                    <p><i class="bi bi-geo-alt-fill me-2"></i>Lima, Perú</p>

                    <h6 class="mt-4">Horario de Atención</h6>
                    <p>Lunes a Viernes: 9:00 AM - 6:00 PM</p>

                    <h6 class="mt-4">Síguenos en Redes</h6>
                    <a href="https://facebook.com" target="_blank" class="me-3"><i class="bi bi-facebook fs-4"></i></a>
                    <a href="https://instagram.com" target="_blank" class="me-3"><i class="bi bi-instagram fs-4"></i></a>
                    <a href="https://twitter.com" target="_blank" class="me-3"><i class="bi bi-twitter fs-4"></i></a>
                    <a href="https://tiktok.com" target="_blank"><i class="bi bi-tiktok fs-4"></i></a>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalContactoSuccess" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark text-white border-warning">
                <div class="modal-header border-bottom-0">
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center pb-5">
                    <i class="bi bi-check-circle-fill text-success display-1 bounce-in mb-4 d-block"></i>
                    <h3 class="text-warning fw-bold">¡Mensaje Enviado!</h3>
                    <p class="fs-5 mt-3">Gracias por escribirnos.</p>
                    <p class="text-white-50">Un asesor se contactará contigo a la brevedad.</p>
                    <button type="button" class="btn btn-warning fw-bold mt-4 px-4" data-bs-dismiss="modal">Entendido</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/header.js"></script>
    
    <script>
        function mostrarModalContacto(event) {
            event.preventDefault(); // Evita que se recargue la página inmediatamente
            const modal = new bootstrap.Modal(document.getElementById('modalContactoSuccess'));
            modal.show();
            
            // Opcional: Limpiar el formulario
            document.getElementById('formContacto').reset();
        }
    </script>

    <jsp:include page="/footer/footer.jsp" />
</body>
</html>