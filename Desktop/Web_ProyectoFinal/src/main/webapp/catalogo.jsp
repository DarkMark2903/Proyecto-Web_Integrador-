<%@page import="model.Categoria"%>
<%@page import="model.Producto"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="es_PE" />
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    java.util.Set<Integer> favoritoIds = (java.util.Set<Integer>) request.getAttribute("favoritoIds");
    if (favoritoIds == null) favoritoIds = new java.util.HashSet<>();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
    <style>
        /* --- FIX VISUAL DEFINITIVO --- */
        
        /* 1. Forzar fondo blanco en el body */
        body {
            background-color: #ffffff !important;
            color: #212529 !important;
        }

        /* 2. Forzar fondo blanco en las tarjetas */
        .card {
            background-color: #ffffff !important;
            border: 1px solid rgba(0,0,0,0.1) !important;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }

        /* 3. CORRECCIÓN DE TEXTOS (Sobrescribir c_style.css) */
        /* Usamos selectores más específicos para ganar prioridad */
        .card-body h5.card-title {
            color: #000000 !important; 
            font-weight: bold;
        }
        
        .card-body p.card-text {
            color: #4f4f4f !important; /* Gris oscuro para descripción */
        }

        /* 4. CORRECCIÓN DEL PRECIO */
        /* Selector muy específico para asegurar que se vea dorado */
        .card-body p.price-tag {
            color: #bfa15f !important; 
            font-size: 1.25rem;
            font-weight: 800;
        }

        /* Título principal */
        h1.text-center {
            color: #212529 !important;
        }

        /* --------------------------------------------------------- */

        .filter-box {
            background-color: #f8f9fa !important; 
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e0cd95; 
            color: #212529 !important; 
        }
        .filter-box label {
            color: #212529 !important;
        }
        
        .btn-golden {
            background-color: #e0cd95;
            color: #000 !important;
            font-weight: bold;
            border: none;
        }
        .btn-golden:hover {
            background-color: #d4b975;
            color: #fff !important;
        }
        
        .card-product {
            transition: transform 0.3s;
        }
        .card-product:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15) !important;
        }
        
        .card-img-top {
            height: 250px;
            object-fit: contain;
            padding: 1rem;
        }
        
        /* Modal estilo oscuro (para contraste con el fondo blanco) */
        .modal-content {
            background-color: #212529;
            color: #fff;
            border: 1px solid #e0cd95;
        }
        .modal-header { border-bottom: 1px solid #444; }
        .modal-footer { border-top: 1px solid #444; }
    </style>
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <div class="container my-5">
        <h1 class="text-center mb-4 fw-bold" style="color: #212529 !important;">NUESTRO CATÁLOGO</h1>

        <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
        <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

        <div class="filter-box mb-5">
            <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="busqueda" class="form-label fw-bold">Buscar Producto</label>
                    <input type="text" class="form-control" id="busqueda" name="busqueda" placeholder="Ej. Polo, Casaca..." value="${param.busqueda}">
                </div>
                <div class="col-md-3">
                    <label for="categoria" class="form-label fw-bold">Categoría</label>
                    <select class="form-select" id="categoria" name="categoria">
                        <option value="0">Todas las categorías</option>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.id_categoria}" ${param.categoria == cat.id_categoria ? 'selected' : ''}>${cat.nombre_categoria}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="orden" class="form-label fw-bold">Ordenar por</label>
                    <select class="form-select" id="orden" name="orden">
                        <option value="">Destacados</option>
                        <option value="precio_asc" ${param.orden == 'precio_asc' ? 'selected' : ''}>Precio: Menor a Mayor</option>
                        <option value="precio_desc" ${param.orden == 'precio_desc' ? 'selected' : ''}>Precio: Mayor a Menor</option>
                        <option value="nombre_asc" ${param.orden == 'nombre_asc' ? 'selected' : ''}>Nombre (A-Z)</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-golden w-100"><i class="bi bi-filter"></i> Filtrar</button>
                    <c:if test="${not empty param.busqueda or param.categoria > 0 or not empty param.orden}">
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-secondary w-100 mt-2"><i class="bi bi-x-circle me-1"></i> Quitar Filtros</a>
                    </c:if>
                </div>
            </form>
        </div>

        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <c:choose>
                <c:when test="${not empty productos}">
                    <c:forEach var="p" items="${productos}">
                        <div class="col">
                            <div class="card card-product h-100">
                                <a href="${pageContext.request.contextPath}/detalle_producto?id=${p.id_producto}">
                                    <c:set var="rutaImg" value="${pageContext.request.contextPath}/img/${p.imagen}" />
                                    <c:if test="${fn:startsWith(p.imagen, 'http')}"><c:set var="rutaImg" value="${p.imagen}" /></c:if>
                                    <img src="${rutaImg}" class="card-img-top p-3" alt="${p.nombre}" onerror="this.src='https://via.placeholder.com/300?text=Sin+Imagen'">
                                </a>
                                <div class="card-body text-center d-flex flex-column">
                                    
                                    <%-- TITULO --%>
                                    <h5 class="card-title text-truncate">${p.nombre}</h5>
                                    
                                    <%-- DESCRIPCION --%>
                                    <p class="card-text small flex-grow-1">
                                        ${p.descripcion.length() > 50 ? p.descripcion.substring(0, 50) : p.descripcion}...
                                    </p>
                                    
                                    <%-- PRECIO (Con clase específica reforzada en CSS) --%>
                                    <p class="price-tag my-2">S/ <fmt:formatNumber value="${p.precio}" pattern="#0.00"/></p>
                                    
                                    <div class="d-flex gap-2 mt-auto">
                                        <% if (usuarioLogueado != null) { %>
                                            <c:choose>
                                                <c:when test="${favoritoIds.contains(p.id_producto)}">
                                                    <a href="${pageContext.request.contextPath}/eliminarFavorito?idProducto=${p.id_producto}" class="btn btn-danger" title="Quitar de Favoritos"><i class="bi bi-heart-fill"></i></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/agregarFavorito?idProducto=${p.id_producto}" class="btn btn-outline-danger" title="Añadir a Favoritos"><i class="bi bi-heart"></i></a>
                                                </c:otherwise>
                                            </c:choose>
                                            <form action="${pageContext.request.contextPath}/agregarCarrito" method="POST" class="d-flex flex-grow-1">
                                                <input type="hidden" name="idProducto" value="${p.id_producto}">
                                                <input type="hidden" name="cantidad" value="1">
                                                <input type="hidden" name="origen" value="catalogo">
                                                <button type="submit" class="btn btn-warning w-100 fw-bold"><i class="bi bi-cart me-2"></i> Añadir</button>
                                            </form>
                                        <% } else { %>
                                            <button type="button" class="btn btn-warning w-100 fw-bold d-flex align-items-center justify-content-center" data-bs-toggle="modal" data-bs-target="#loginRequiredModal">
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
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-search display-1 text-muted"></i>
                        <h3 class="mt-3 text-muted">No se encontraron productos.</h3>
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-dark">Ver Todo</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="modal fade" id="loginRequiredModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-warning fw-bold"><i class="bi bi-exclamation-circle me-2"></i>Iniciar Sesión</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <p class="fs-5">Para agregar productos a tu carrito, necesitas ingresar a tu cuenta.</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-warning fw-bold px-4">Ir a Iniciar Sesión</a>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/footer/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>