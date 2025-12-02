<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Mi Intranet - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <main class="container my-5">
        <div class="row">
            <div class="col-12">
                <h1 class="text-center mb-4 fw-bold">Bienvenido, <%= usuarioLogueado.getNombre() %></h1>
                <p class="lead text-center text-golden">Intranet de cliente - Gestiona tus datos y pedidos.</p>
                <hr>
            </div>
        </div>
        
        <div class="row g-4 justify-content-center pt-4">
            
            <div class="col-lg-3 col-md-6">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-person-gear fs-1 text-golden mb-3"></i>
                        <h5 class="card-title fw-bold">Editar Información</h5>
                        <p class="card-text text-muted small">Actualiza tus datos personales y contraseña.</p>
                        <a href="${pageContext.request.contextPath}/cliente/editar_info.jsp" class="btn btn-dark w-100 mt-2">Gestionar</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-box-seam fs-1 text-golden mb-3"></i>
                        <h5 class="card-title fw-bold">Mis Pedidos</h5>
                        <p class="card-text text-muted small">Revisa el historial y estado de tus compras.</p>
                        <%-- FIX: Enlace apunta al Servlet /mis-pedidos, no al JSP --%>
                        <a href="${pageContext.request.contextPath}/mis-pedidos" class="btn btn-dark w-100 mt-2">Ver Pedidos</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-heart fs-1 text-golden mb-3"></i>
                        <h5 class="card-title fw-bold">Mis Favoritos</h5>
                        <p class="card-text text-muted small">Consulta los productos que te encantaron.</p>
                        <a href="${pageContext.request.contextPath}/misFavoritos" class="btn btn-dark w-100 mt-2">Ver Favoritos</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-body text-center p-4">
                         <i class="bi bi-credit-card fs-1 text-golden mb-3"></i>
                        <h5 class="card-title fw-bold">Mis Tarjetas</h5>
                        <p class="card-text text-muted small">Administra tus métodos de pago guardados.</p>
                        <a href="${pageContext.request.contextPath}/misTarjetas" class="btn btn-dark w-100 mt-2">Ver Tarjetas</a>
                    </div>
                </div>
            </div>
            
        </div>
        
        <div class="row mt-5">
           <div class="col-12 text-center">
                 <a href="#" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#confirmarEliminarModal">
                    <i class="bi bi-trash me-2"></i> Eliminar Cuenta Permanentemente
                </a>
            </div>
        </div>
        
    </main>
    
    <%-- MODAL DE CONFIRMACIÓN --%>
    <div class="modal fade" id="confirmarEliminarModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title text-warning"><i class="bi bi-person-x me-2"></i> Confirmación de Cierre de Cuenta</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Esta acción es **definitiva** y **no se puede deshacer**.</p>
                    <p class="text-danger">Al confirmar, perderá permanentemente el acceso a su historial de pedidos, favoritos y datos guardados.</p>
                    <p class="text-warning mt-3">¿Desea continuar con la eliminación de su cuenta?</p>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Mantener Mi Cuenta</button>
                    <a href="${pageContext.request.contextPath}/eliminarCuenta" class="btn btn-danger">Sí, Eliminar Permanentemente</a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>