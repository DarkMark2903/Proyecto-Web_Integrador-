<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style> .carousel-item { height: 65vh; min-height: 350px; background: no-repeat center center scroll; background-size: cover; } .carousel-caption { bottom: 25%; background-color: rgba(17, 17, 17, 0.6); padding: 20px; border-radius: 5px; } .card-product:hover { box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.25) !important; transform: translateY(-5px); transition: all 0.3s ease; } .text-golden { color: #e0cd95; } </style>
</head>
<body>
    <jsp:include page="/header/header.jsp" />
    <main>
        <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-indicators"><button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button><button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button><button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button></div>
            <div class="carousel-inner">
                <div class="carousel-item active" style="background-image: url('${pageContext.request.contextPath}/img/12.jpg');"><div class="carousel-caption text-center"><h1 class="display-3 fw-bold text-golden">MODA QUE TE DEFINE</h1><p class="lead text-white-50">Descubre las últimas tendencias.</p><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning btn-lg mt-3 fw-bold">Ver Catálogo</a></div></div>
                <div class="carousel-item" style="background-image: url('${pageContext.request.contextPath}/img/10.jpg');"><div class="carousel-caption text-center"><h1 class="display-3 fw-bold text-golden">OFERTAS DE TEMPORADA</h1><p class="lead text-white-50">Hasta 50% de descuento.</p><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning btn-lg mt-3 fw-bold">Ir a Ofertas</a></div></div>
                <div class="carousel-item" style="background-image: url('${pageContext.request.contextPath}/img/11.jpg');"><div class="carousel-caption text-center"><h1 class="display-3 fw-bold text-golden">ENVÍO GRATIS</h1><p class="lead text-white-50">En compras superiores a S/ 200.</p><a href="${pageContext.request.contextPath}/contacto.jsp" class="btn btn-warning btn-lg mt-3 fw-bold">Más Detalles</a></div></div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button><button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
        </div>
        <section class="container my-5 py-3">
            <h2 class="text-center mb-5 fw-light text-uppercase">PRODUCTOS MÁS VENDIDOS</h2>
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="card card-product h-100 border-0 shadow-lg text-center">
                        <img src="${pageContext.request.contextPath}/img/1.PNG" class="card-img-top p-3" alt="P1" style="height: 250px; object-fit: contain;" onerror="this.src='https://via.placeholder.com/250?text=Imagen+No+Disp.'">
                        <div class="card-body bg-dark text-white"><h5 class="card-title fw-bold text-golden">Polo Casual</h5><p class="text-white-50">Algodón Pima</p><p class="fs-4 fw-bold text-warning">S/ 49.90</p><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning w-100 fw-bold"><i class="bi bi-cart me-2"></i> Añadir</a></div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6"><div class="card card-product h-100 border-0 shadow-lg text-center"><img src="${pageContext.request.contextPath}/img/7.jpg" class="card-img-top p-3" alt="P2" style="height: 250px; object-fit: contain;" onerror="this.src='https://via.placeholder.com/250?text=Imagen+No+Disp.'"><div class="card-body bg-dark text-white"><h5 class="card-title fw-bold text-golden">Chaqueta Denim</h5><p class="text-white-50">Edición Limitada</p><p class="fs-4 fw-bold text-warning">S/ 189.90</p><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning w-100 fw-bold"><i class="bi bi-cart me-2"></i> Añadir</a></div></div></div>
                <div class="col-lg-3 col-md-6"><div class="card card-product h-100 border-0 shadow-lg text-center"><img src="${pageContext.request.contextPath}/img/4.jpg" class="card-img-top p-3" alt="P3" style="height: 250px; object-fit: contain;" onerror="this.src='https://via.placeholder.com/250?text=Imagen+No+Disp.'"><div class="card-body bg-dark text-white"><h5 class="card-title fw-bold text-golden">Zapatillas</h5><p class="text-white-50">Comodidad superior</p><p class="fs-4 fw-bold text-warning">S/ 120.00</p><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning w-100 fw-bold"><i class="bi bi-cart me-2"></i> Añadir</a></div></div></div>
                <div class="col-lg-3 col-md-6"><div class="card card-product h-100 border-0 shadow-lg text-center"><img src="${pageContext.request.contextPath}/img/polos-personalizados-made-in-peru.jpg" class="card-img-top p-3" alt="P4" style="height: 250px; object-fit: contain;" onerror="this.src='https://via.placeholder.com/250?text=Imagen+No+Disp.'"><div class="card-body bg-dark text-white"><h5 class="card-title fw-bold text-golden">Gorra Style</h5><p class="text-white-50">Ajuste Perfecto</p><p class="fs-4 fw-bold text-warning">S/ 29.90</p><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning w-100 fw-bold"><i class="bi bi-cart me-2"></i> Añadir</a></div></div></div>
            </div>
            <div class="text-center mt-5"><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-dark btn-lg fw-bold">Ver Todos los Productos</a></div>
        </section>
        <section class="container my-5 py-5 bg-light rounded-3">
            <h2 class="text-center mb-5 fw-light text-uppercase">¿POR QUÉ ELEGIRNOS?</h2>
            <div class="row text-center">
                <div class="col-md-4 mb-4"><i class="bi bi-truck display-4 text-golden"></i><h5 class="mt-3 fw-bold">Envío Rápido</h5><p class="text-muted">Recibe tu pedido en 24-48h en Lima.</p></div>
                <div class="col-md-4 mb-4"><i class="bi bi-patch-check-fill display-4 text-golden"></i><h5 class="mt-3 fw-bold">Calidad Garantizada</h5><p class="text-muted">Productos seleccionados.</p></div>
                <div class="col-md-4 mb-4"><i class="bi bi-arrow-return-left display-4 text-golden"></i><h5 class="mt-3 fw-bold">Devoluciones Fáciles</h5><p class="text-muted">30 días para cambiar.</p></div>
            </div>
        </section>
    </main>
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>