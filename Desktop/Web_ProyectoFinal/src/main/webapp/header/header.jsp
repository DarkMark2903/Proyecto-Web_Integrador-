<%@page import="model.Usuario"%>
<%@page pageEncoding="UTF-8" %> <%-- Agregado para soportar tildes correctamente --%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    Integer carritoContador = (Integer) session.getAttribute("carritoContador");
    if (carritoContador == null) { carritoContador = 0; }
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark py-2 sticky-top border-bottom border-warning">
    <div class="container-fluid px-lg-5 align-items-center"> 
        
        <%-- LOGO QUE APUNTA AL SERVLET INICIO --%>
        <%-- Al usar contextPath, este enlace funciona desde cualquier subcarpeta --%>
        <a class="navbar-brand me-5" href="${pageContext.request.contextPath}/inicio">
            <img src="${pageContext.request.contextPath}/img/logo_sin_fondo.png" alt="Peruvian&Style Logo" height="80"> 
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavClassic">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-center" id="navbarNavClassic">
            <ul class="navbar-nav text-uppercase fw-bold">
                <%-- ENLACE INICIO APUNTA AL SERVLET --%>
                <li class="nav-item"><a class="nav-link text-white mx-2" href="${pageContext.request.contextPath}/inicio">Inicio</a></li>
                <li class="nav-item"><a class="nav-link text-white mx-2" href="${pageContext.request.contextPath}/catalogo">Catálogo</a></li>
                <li class="nav-item"><a class="nav-link text-white mx-2" href="${pageContext.request.contextPath}/acerca.jsp">Acerca de Nosotros</a></li>
                <li class="nav-item"><a class="nav-link text-white mx-2" href="${pageContext.request.contextPath}/contacto.jsp">Contacto</a></li>
            </ul>
        </div>

        <div class="d-flex align-items-center ms-auto">
            <% if (usuarioLogueado != null) { %>
           
                <a href="${pageContext.request.contextPath}/misFavoritos" class="btn btn-link text-white me-2 header-icon-link">
                    <i class="bi bi-heart fs-4"></i>
                </a>
    
                <div class="dropdown me-2">
                    <a class="btn btn-link text-white header-icon-link" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown">
                       <i class="bi bi-person fs-4"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                        <li><h6 class="dropdown-header">Hola, <%= usuarioLogueado.getNombre() %>!</h6></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cliente/cuenta.jsp">Mi Intranet</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/mis-pedidos">Mis Pedidos</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/cerrarSesion">Cerrar Sesión</a></li>
                    </ul>
                </div>
         
                <a href="${pageContext.request.contextPath}/carrito" class="btn btn-link text-white position-relative header-icon-link">
                    <i class="bi bi-cart fs-4"></i>
                    <% if (carritoContador > 0) { %>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark">
                            <%= carritoContador %>
                        </span>
                    <% } %>
               </a>
            <% } else { %>
                 <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-warning btn-sm ms-2 fw-bold">Ingresar</a>
            <% } %>
        </div>
    </div>
</nav>