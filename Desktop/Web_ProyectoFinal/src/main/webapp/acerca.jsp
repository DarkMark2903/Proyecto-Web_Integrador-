<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Acerca de Nosotros - Peruvian&Style</title>
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
        <h1>Acerca de Peruvian&Style</h1>

        <div class="section-block">
            <h5><i class="bi bi-compass-fill me-2 text-warning"></i>Nuestra Historia</h5>
            <p>
                Peruvian&Style nace de la pasión por la moda y la **tradición peruana**. Combinamos tejidos
                artesanales con diseños modernos, ofreciendo ropa elegante, cómoda y de alta calidad.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-arrow-right-circle-fill me-2 text-warning"></i>Misión</h5>
            <p>
                Proporcionar productos de moda de alta calidad, elaborados con materiales cuidadosamente seleccionados,
                mientras garantizamos una gestión eficiente y transparente de nuestros procesos internos.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-eye-fill me-2 text-warning"></i>Visión</h5>
            <p>
                Ser reconocidos como la **marca líder en moda peruana**, destacando por la calidad de nuestros productos,
                innovación y compromiso con nuestros clientes y colaboradores.
            </p>
        </div>

        <div class="section-block">
            <h5><i class="bi bi-heart-fill me-2 text-warning"></i>Valores</h5>
            <p>
                Calidad, innovación, ética, respeto por la tradición, sostenibilidad y satisfacción del cliente.
            </p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/header.js"></script>

    <jsp:include page="/footer/footer.jsp" />
</body>
</html>