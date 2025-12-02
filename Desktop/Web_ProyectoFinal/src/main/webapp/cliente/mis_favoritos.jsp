<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Favoritos - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
    <style>
        .card-product:hover {
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.25) !important;
            transform: translateY(-5px);
            transition: all 0.3s ease;
        }
        .text-golden { color: #c5a059; }
    </style>
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <main class="container my-5">
        <div class="row">
            <div class="col-12 text-center">
                <h1 class="mb-4 fw-bold">Mis Favoritos</h1>
                <p class="lead text-golden">Consulta los productos que te encantaron.</p>
                <hr>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-12">
                <div class="card shadow-lg border-0 p-4">
                    <%-- Mensajes de notificación --%>
                    <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                    <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

                    <c:choose>
                        <%-- Aquí se usa la lista 'favoritos' enviada por MisFavoritosController --%>
                        <c:when test="${not empty favoritos}">
                            <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
                                <c:forEach var="p" items="${favoritos}">
                                    <div class="col">
                                        <div class="card card-product h-100 text-center">
                                            <a href="${pageContext.request.contextPath}/detalle_producto?id=${p.id_producto}">
                                                <img src="${pageContext.request.contextPath}/img/${p.imagen}" class="card-img-top p-3" alt="${p.nombre}" style="height: 200px; object-fit: contain;">
                                            </a>
                                            <div class="card-body d-flex flex-column">
                                                <h5 class="card-title fw-bold text-truncate">${p.nombre}</h5>
                                                <p class="fs-5 fw-bold text-warning">S/ ${p.precio}</p>
                                                <div class="d-grid gap-2 mt-auto">
                                                    <%-- Enlace para eliminar el favorito --%>
                                                    <a href="${pageContext.request.contextPath}/eliminarFavorito?idProducto=${p.id_producto}" class="btn btn-danger btn-sm" title="Quitar de Favoritos">
                                                        <i class="bi bi-x-circle me-2"></i> Quitar
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/detalle_producto?id=${p.id_producto}" class="btn btn-dark">Ver Detalle</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="bi bi-heart-fill display-4 text-golden"></i>
                                <h4 class="mt-3 text-golden">Aún no has agregado productos a tus favoritos.</h4>
                                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning mt-3">Explorar Catálogo</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/cliente/cuenta.jsp" class="btn btn-dark"><i class="bi bi-arrow-left me-2"></i>Volver a Mi Intranet</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>