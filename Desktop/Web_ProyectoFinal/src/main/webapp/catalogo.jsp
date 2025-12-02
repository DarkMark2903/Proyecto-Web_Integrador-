<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="es_PE" />
<%
    // Obtener el usuario logueado para mostrar el botón de favoritos condicionalmente
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .filter-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e0cd95; /* Borde dorado suave */
        }
        .text-golden { color: #c5a059; }
        .btn-golden {
            background-color: #e0cd95;
            color: #000;
            font-weight: bold;
            border: none;
        }
        .btn-golden:hover {
            background-color: #d4b975;
            color: #fff;
        }
        .card-product {
            transition: transform 0.3s;
            border: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .card-product:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 12px rgba(0,0,0,0.15);
        }
        .price-tag {
            font-size: 1.25rem;
            font-weight: 700;
            color: #bfa15f;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <div class="container my-5">
        <h1 class="text-center mb-4 fw-bold">NUESTRO CATÁLOGO</h1>

        <%-- Mensajes de Notificación (Éxito o Error) --%>
        <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
        <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

        <div class="filter-box mb-5">
            <form action="catalogo" method="GET" class="row g-3 align-items-end">
                
                <div class="col-md-4">
                    <label for="busqueda" class="form-label fw-bold">Buscar Producto</label>
                    <input type="text" class="form-control" id="busqueda" name="busqueda" 
                           placeholder="Ej. Polo, Casaca..." value="${busquedaActual}">
                </div>

                <div class="col-md-3">
                    <label for="categoria" class="form-label fw-bold">Categoría</label>
                    <select class="form-select" id="categoria" name="categoria">
                        <option value="0">Todas las categorías</option>
                   
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.id_categoria}" ${categoriaActual == cat.id_categoria ?
'selected' : ''}>
                                ${cat.nombre_categoria}
                            </option>
                        </c:forEach>
              
                    </select>
                </div>

                <div class="col-md-3">
                    <label for="orden" class="form-label fw-bold">Ordenar por</label>
                    <select class="form-select" id="orden" name="orden">
              
                        <option value="">Destacados</option>
                        <option value="precio_asc" ${ordenActual == 'precio_asc' ?
'selected' : ''}>Precio: Menor a Mayor</option>
                        <option value="precio_desc" ${ordenActual == 'precio_desc' ?
'selected' : ''}>Precio: Mayor a Menor</option>
                        <option value="nombre_asc" ${ordenActual == 'nombre_asc' ?
'selected' : ''}>Nombre (A-Z)</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <button type="submit" class="btn btn-golden w-100">
                        <i class="bi bi-filter"></i> Filtrar
                    </button>
                    
                    <%-- INICIO: Botón Quitar Filtros (Visible solo si hay un filtro activo) --%>
                    <c:if test="${not empty busquedaActual or categoriaActual > 0 or not empty ordenActual}">
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-secondary w-100 mt-2">
                            <i class="bi bi-x-circle me-1"></i> Quitar Filtros
                        </a>
                    </c:if>
                    <%-- FIN: Botón Quitar Filtros --%>
                </div>
            </form>
        </div>

        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <c:choose>
            
                <c:when test="${not empty productos}">
                    <c:forEach var="p" items="${productos}">
                        <div class="col">
                            <div class="card card-product h-100">
               
                                <a href="detalle_producto?id=${p.id_producto}">
                                    <img src="${pageContext.request.contextPath}/img/${p.imagen}" 
                                         class="card-img-top p-3" 
 
                                         alt="${p.nombre}" 
                                         style="height: 250px;
object-fit: contain;">
                                </a>
                                
                                <div class="card-body text-center 
d-flex flex-column">
                                    <h5 class="card-title fw-bold text-truncate">${p.nombre}</h5>
                                    <p class="card-text text-muted small flex-grow-1">
                    
                                        ${p.descripcion.length() > 50 ? p.descripcion.substring(0, 50) : p.descripcion}...
                                    </p>
                                    <p 
class="price-tag my-2">S/ ${p.precio}</p>
                                    
                                    <div class="d-flex gap-2 mt-auto">
                                        
                                        <%-- INICIO: LÓGICA CONDICIONAL DEL BOTÓN DE FAVORITOS --%>
                                        <% if (usuarioLogueado != null) { %>
                                            <c:choose>
                                                <%-- Verifica si el ID del producto está en el Set 'favoritoIds' --%>
                                                <c:when test="${favoritoIds.contains(p.id_producto)}">
                                                    <a href="${pageContext.request.contextPath}/eliminarFavorito?idProducto=${p.id_producto}" 
                                                       class="btn btn-danger" title="Quitar de Favoritos">
                                                        <i class="bi bi-heart-fill"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/agregarFavorito?idProducto=${p.id_producto}" 
                                                       class="btn btn-outline-danger" title="Añadir a Favoritos">
                                                        <i class="bi bi-heart"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        <% } %>
                                        <%-- FIN: LÓGICA CONDICIONAL DEL BOTÓN DE FAVORITOS --%>
                              
                                        <%-- Botón Añadir al Carrito (Siempre apunta al Servlet) --%>
                                        <form action="${pageContext.request.contextPath}/agregarCarrito" method="POST" class="d-flex flex-grow-1">
                                            <input type="hidden" name="idProducto" value="${p.id_producto}">
                                            <input type="hidden" name="cantidad" value="1">
                                            <button type="submit" class="btn btn-warning w-100 fw-bold">
                                                <i class="bi bi-cart me-2"></i> Añadir
                                            </button>
                                        </form>
                                        
                                    </div>
            
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
        
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-search display-1 text-muted"></i>
                  
                        <h3 class="mt-3 text-muted">No se encontraron productos.</h3>
                        <p>Intenta cambiar los filtros de búsqueda.</p>
                        <a href="catalogo" class="btn btn-outline-dark">Ver Todo</a>
                    </div>
            
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="/footer/footer.jsp" />

    <script 
src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>