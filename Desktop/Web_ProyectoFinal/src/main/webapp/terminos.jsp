<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Términos y Condiciones - Peruvian&Style</title>
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
        <h1>Términos y Condiciones</h1>

        <div class="section-block">
            <h5><i class="bi bi-check-circle-fill me-2 text-warning"></i>Aceptación de términos</h5>
            <p>
                Al usar el sitio web de Peruvian&Style, confirmas que has leído y aceptas los términos y condiciones aquí establecidos.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-credit-card-fill me-2 text-warning"></i>Precios y pagos</h5>
            <p>
                Todos los precios mostrados incluyen impuestos (IGV) y están sujetos a cambios sin previo aviso. Garantizamos que nuestros pagos son seguros y validados.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-truck-flatbed me-2 text-warning"></i>Envíos y devoluciones</h5>
            <p>
                Los tiempos de entrega dependen de la disponibilidad del producto y la ubicación. Las devoluciones se rigen por nuestra <a href="devoluciones.jsp" class="text-warning text-decoration-none">Política de Devoluciones</a>.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-pencil-square me-2 text-warning"></i>Modificaciones</h5>
            <p>
                Peruvian&Style se reserva el derecho de modificar estos términos en cualquier momento. Se recomienda revisar esta página periódicamente.
            </p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/header.js"></script>

    <jsp:include page="/footer/footer.jsp" />
</body>
</html>