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
    <title>Editar Información - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <main class="container my-5">
        <div class="row">
            <div class="col-12 text-center">
                <h1 class="mb-4 fw-bold">Editar Información</h1>
                <p class="lead text-golden">Actualiza tus datos personales y contraseña.</p>
                <hr>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-lg border-0 p-4">
                    <%-- Mensajes de notificación --%>
                    <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                    <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

                    <form action="${pageContext.request.contextPath}/editarInfo" method="POST">
                        <div class="row g-3">
                            <div class="col-md-6 mb-3">
                                <label for="nombre" class="form-label fw-bold">Nombre:</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" value="<%= usuarioLogueado.getNombre() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="apellido" class="form-label fw-bold">Apellido:</label>
                                <input type="text" class="form-control" id="apellido" name="apellido" value="<%= usuarioLogueado.getApellido() %>" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label for="email" class="form-label fw-bold">Correo Electrónico:</label>
                                <input type="email" class="form-control" id="email" name="correo" value="<%= usuarioLogueado.getCorreo() %>" disabled>
                            </div>
                             <div class="col-md-6 mb-3">
                                <label for="telefono" class="form-label fw-bold">Teléfono:</label>
                                <input type="text" class="form-control" id="telefono" name="telefono" value="<%= usuarioLogueado.getTelefono() %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="direccion" class="form-label fw-bold">Dirección Principal:</label>
                                <input type="text" class="form-control" id="direccion" name="direccion" value="<%= usuarioLogueado.getDireccion() %>">
                            </div>
                            
                            <div class="col-12">
                                <hr>
                                <h5 class="fw-bold">Cambiar Contraseña (Opcional)</h5>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="nuevaContrasena" class="form-label fw-bold">Nueva Contraseña:</label>
                                <input type="password" class="form-control" id="nuevaContrasena" name="nuevaContrasena">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmarContrasena" class="form-label fw-bold">Confirmar Contraseña:</label>
                                <input type="password" class="form-control" id="confirmarContrasena" name="confirmarContrasena">
                            </div>

                            <div class="col-12 text-center mt-4">
                                <button type="submit" class="btn btn-warning btn-lg">Guardar Cambios</button>
                                <a href="${pageContext.request.contextPath}/cliente/cuenta.jsp" class="btn btn-secondary btn-lg ms-3">Volver</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>