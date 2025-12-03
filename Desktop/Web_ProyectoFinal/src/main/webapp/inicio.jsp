<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="es_PE" />
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    java.util.Set<Integer> favoritoIds = (java.util.Set<Integer>) request.getAttribute("favoritoIds");
    if (favoritoIds == null) favoritoIds = new java.util.HashSet<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style> 
        .carousel-item { height: 65vh; min-height: 350px; background: no-repeat center center scroll; background-size: cover; } 
        .carousel-caption { bottom: 25%; background-color: rgba(17, 17, 17, 0.6); padding: 20px; border-radius: 5px; } 
        .card-product { transition: transform 0.3s ease; } 
        .card-product:hover { box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.25) !important; transform: translateY(-5px); } 
        .text-golden { color: #e0cd95; } 
        /* Estilo específico para Home */
        .card-body-home { background-color: #212529; color: white; }
        .card-img-top { height: 250px; object-fit: contain; padding: 1rem; background-color: white; }
    </style>
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
            <h2 class="text-center mb-5 fw-light text-uppercase">DESTACADOS</h2>
            
            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty productosTop}">
                        <c:forEach var="p" items="${productosTop}">
                            <div class="col-lg-3 col-md-6">
                                <div class="card card-product h-100 border-0 shadow-lg text-center">
                                    
                                    <a href="${pageContext.request.contextPath}/detalle_producto?id=${p.id_producto}">
                                        <c:set var="rutaImg" value="${pageContext.request.contextPath}/img/${p.imagen}" />
                                        <c:if test="${fn:startsWith(p.imagen, 'http')}"><c:set var="rutaImg" value="${p.imagen}" /></c:if>
                                        <img src="${rutaImg}" class="card-img-top" alt="${p.nombre}" onerror="this.src='https://via.placeholder.com/250?text=Sin+Imagen'">
                                    </a>
                                    
                                    <div class="card-body card-body-home">
                                        <h5 class="card-title fw-bold text-golden text-truncate">${p.nombre}</h5>
                                        <p class="text-white-50 small flex-grow-1">
                                            <%-- FIX: Manejo seguro de substring para evitar error si descripción es nula o corta --%>
                                            <c:out value="${fn:length(p.descripcion) > 40 ? fn:substring(p.descripcion, 0, 40) : p.descripcion}" />...
                                        </p>
                                        <p class="fs-4 fw-bold text-warning">S/ <fmt:formatNumber value="${p.precio}" pattern="#0.00"/></p>
                                        
                                        <div class="d-grid gap-2">
                                            <% if (usuarioLogueado != null) { %>
                                                <form action="${pageContext.request.contextPath}/agregarCarrito" method="POST">
                                                    <input type="hidden" name="idProducto" value="${p.id_producto}">
                                                    <input type="hidden" name="cantidad" value="1">
                                                    <input type="hidden" name="origen" value="inicio">
                                                    <button type="submit" class="btn btn-warning w-100 fw-bold"><i class="bi bi-cart me-2"></i> Añadir</button>
                                                </form>
                                            <% } else { %>
                                                <button type="button" class="btn btn-warning w-100 fw-bold" data-bs-toggle="modal" data-bs-target="#loginRequiredModal">
                                                    <i class="bi bi-cart me-2"></i> Añadir
                                                </button>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center">
                            <p class="text-muted">Cargando productos destacados...</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-dark btn-lg fw-bold">Ver Todos los Productos</a>
            </div>
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

    <div class="modal fade" id="loginRequiredModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark text-white" style="border: 1px solid #e0cd95;">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-warning"><i class="bi bi-lock-fill me-2"></i>Iniciar Sesión</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <p class="fs-5">Necesitas ingresar a tu cuenta para comprar.</p>
                </div>
                <div class="modal-footer border-secondary justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-warning fw-bold">Ir al Login</a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>