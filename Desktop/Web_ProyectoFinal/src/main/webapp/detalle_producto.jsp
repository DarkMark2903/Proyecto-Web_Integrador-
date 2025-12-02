<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="es_PE" />
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle de Producto - Peruvian&Style</title>
    
    <%-- ENLACES DE ESTILO --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <%-- FIX 1: Re-incluir c_style.css (que contiene la elegancia) --%>
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
    
    <%-- FIX 2: Override CSS para forzar el tema claro en el cuerpo principal --%>
    <style>
        body {
            /* Anula el fondo negro de c_style.css para este JSP */
            background-color: #ffffff !important; 
            color: #121212 !important; /* Asegura que el texto sea oscuro */
        }
        /* Las tarjetas y el header deben mantener su estilo original de c_style.css */
        .card { 
            background-color: #f8f9fa; /* Fondo blanco/gris claro para la tarjeta */
            border: 1px solid #dee2e6;
            color: #121212;
        }
        .card-body p, .card-body strong, .card-body h1, .card-body h5 {
            color: #121212 !important;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <main class="container my-5">
        <div class="row">
            <div class="col-12">
                 <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-sm btn-outline-dark mb-4"><i class="bi bi-arrow-left me-2"></i> Volver al Catálogo</a>
            </div>
        </div>
        
        <div class="row">
            <c:if test="${not empty producto}">
                <div class="col-md-6 text-center">
                    <img src="${pageContext.request.contextPath}/img/${producto.imagen}" class="img-fluid rounded" alt="${producto.nombre}" style="max-height: 500px; object-fit: contain;">
                </div>

                <div class="col-md-6">
                    <h1 class="fw-bold mb-3">${producto.nombre}</h1>
                    <p class="lead text-warning fs-3">S/ <fmt:formatNumber value="${producto.precio}" pattern="#0.00" /></p>
                    
                    <p>${producto.descripcion}</p>
                    
                    <hr>

                    <p class="fw-bold">Disponibilidad:</p>
                    <c:choose>
                        <c:when test="${producto.stock > 0}">
                            <p class="text-success fw-bold"><i class="bi bi-check-circle-fill me-2"></i> En Stock (${producto.stock} unidades)</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-danger fw-bold"><i class="bi bi-x-circle-fill me-2"></i> Agotado</p>
                        </c:otherwise>
                    </c:choose>
                    
                    <%-- LÓGICA DE BOTÓN DE CARRITO Y CANTIDAD --%>
                    <c:if test="${producto.stock > 0}">
                        <form action="${pageContext.request.contextPath}/agregarCarrito" method="POST" class="mt-4">
                            <input type="hidden" name="idProducto" value="${producto.id_producto}">
                            
                            <div class="d-flex align-items-center mb-4">
                                <label for="cantidad" class="form-label me-3 fw-bold">Cantidad:</label>
                                <input type="number" 
                                       name="cantidad" 
                                       id="cantidad" 
                                       value="1" 
                                       min="1" 
                                       max="10" 
                                       class="form-control" 
                                       style="width: 100px;" 
                                       required>
                            </div>
                            
                            <% if (usuarioLogueado != null) { %>
                                <button type="submit" class="btn btn-warning btn-lg w-100 fw-bold">
                                    <i class="bi bi-cart me-2"></i> Añadir al Carrito
                                </button>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/index.jsp?error=Debe iniciar sesión para agregar productos al carrito." 
                                   class="btn btn-warning btn-lg w-100 fw-bold">
                                    <i class="bi bi-lock me-2"></i> Iniciar Sesión para Comprar
                                </a>
                            <% } %>
                        </form>
                    </c:if>
                    
                    <%-- Botón de Favoritos (si aplica) --%>
                    <c:if test="${usuarioLogueado != null}">
                        <div class="mt-3">
                           <%-- ... (Lógica de favoritos si existe) ... --%>
                        </div>
                    </c:if>
                </div>
            </c:if>
            <c:if test="${empty producto}">
                <div class="col-12 text-center py-5">
                    <h3 class="text-danger">Producto no encontrado.</h3>
                </div>
            </c:if>
        </div>
    </main>

    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>