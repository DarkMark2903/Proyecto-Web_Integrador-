<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Política de Privacidad - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        .content-container {
            max-width: 900px;
            margin: 50px auto;
            padding: 0 15px;
        }
        h1 {
            color: #e0cd95; /* Dorado */
            font-weight: 700;
            margin-bottom: 40px;
            text-align: center;
        }
        h5 {
            color: #000;
            font-weight: 600;
            margin-top: 30px;
            border-left: 5px solid #e0cd95; /* Borde dorado */
            padding-left: 10px;
        }
        .section-block {
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid #eee;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="/header/header.jsp" />

    <div class="content-container">
        <h1>Política de Privacidad</h1>

        <div class="section-block">
            <h5><i class="bi bi-person-check-fill me-2"></i>Recopilación de información</h5>
            <p>
                Recopilamos datos personales (nombre, correo electrónico, dirección, teléfono)
                **únicamente para procesar tus pedidos y envíos**, asegurando la entrega correcta de tus productos.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-shield-lock-fill me-2"></i>Uso de la información</h5>
            <p>
                Tu información se usa solo para fines internos, como mejorar nuestros servicios y la experiencia de compra.
                **Nunca se comparte con terceros** sin tu consentimiento explícito.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-key-fill me-2"></i>Seguridad</h5>
            <p>
                Implementamos **medidas de seguridad avanzadas** para proteger tus datos contra accesos no autorizados,
                utilizando cifrado y protocolos seguros.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-pencil-square me-2"></i>Derechos del usuario</h5>
            <p>
                Tienes derecho a solicitar la actualización, corrección o eliminación de tus datos personales en cualquier momento.
                Simplemente escríbenos a <b>peruvianstyle@gmail.com</b>.
            </p>
        </div>
    </div>

    <jsp:include page="/footer/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>