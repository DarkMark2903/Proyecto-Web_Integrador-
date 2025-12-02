<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Política de Devoluciones - Peruvian&Style</title>
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
        <h1>Política de Devoluciones</h1>

        <div class="section-block">
            <h5><i class="bi bi-clock-history me-2"></i>Plazo para devoluciones</h5>
            <p>
                Los clientes pueden solicitar devoluciones dentro de los **7 días calendario** posteriores a la recepción del producto.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-tag me-2"></i>Condiciones del producto</h5>
            <p>
                Los productos deben estar **sin uso**, con etiquetas y empaques intactos. Por razones de higiene,
                no se aceptan devoluciones de artículos en oferta o ropa interior.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-envelope me-2"></i>Procedimiento</h5>
            <p>
                Para iniciar la devolución, contacta a nuestro equipo de soporte:
                <ul>
                    <li>Correo: <b>peruvianstyle@gmail.com</b></li>
                    <li>Teléfono: +51 933 362 455</li>
                </ul>
            </p>
        </div>
    </div>

    <jsp:include page="/footer/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>