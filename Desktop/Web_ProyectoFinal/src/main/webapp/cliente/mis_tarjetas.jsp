<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="es_PE" />
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        // Si no hay usuario logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Tarjetas - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
    <style>
        .text-golden { color: #c5a059; }
        .card-simulada { 
            background: linear-gradient(135deg, #2b2b2b, #1f1f1f);
            color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.4);
        }
    </style>
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <main class="container my-5">
        <div class="row">
            <div class="col-12 text-center">
                <h1 class="mb-4 fw-bold">Mis Tarjetas</h1>
                <p class="lead text-golden">Administra tus métodos de pago guardados.</p>
                <hr>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-lg border-0 p-4">
                    <%-- Mensajes de notificación --%>
                    <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                    <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>



                    <c:choose>
                        <c:when test="${not empty listaTarjetas}">
                            <div class="row g-4">
                                <c:forEach var="tarjeta" items="${listaTarjetas}">
                                    <div class="col-md-6">
                                        <div class="card card-simulada p-3">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <i class="bi bi-credit-card-fill fs-2 text-warning"></i>
                                                <small class="text-uppercase">${tarjeta.tipo}</small>
                                            </div>
                                            <h4 class="mt-3">**** **** **** ${tarjeta.ultimosDigitos}</h4>
                                            <div class="d-flex justify-content-between small mt-2">
                                                <span>${tarjeta.nombreTitular}</span>
                                                <span>EXP: ${tarjeta.fechaExpiracion}</span>
                                            </div>
                                            <div class="mt-2 text-end">
<%-- Usamos un formulario para enviar POST al mismo servlet /misTarjetas --%>
<form action="${pageContext.request.contextPath}/misTarjetas" method="post" style="display:inline;">
    <input type="hidden" name="idTarjeta" value="${tarjeta.id_tarjeta}">
    <button type="submit" class="btn btn-sm btn-outline-danger">
        <i class="bi bi-trash"></i> Eliminar
    </button>
</form>                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="bi bi-credit-card-2-front display-4 text-golden"></i>
                                <h4 class="mt-3 text-golden">No tienes métodos de pago guardados.</h4>
                                <p class="text-muted">Añade una tarjeta para finalizar tus compras más rápido.</p>
                                <button class="btn btn-warning mt-3" data-bs-toggle="modal" data-bs-target="#registrarTarjetaModal">
                                    <i class="bi bi-plus-circle me-2"></i>Añadir Tarjeta
                                </button>
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
    
    <%-- INICIO: MODAL DE REGISTRO DE TARJETA --%>
    <div class="modal fade" id="registrarTarjetaModal" tabindex="-1" aria-labelledby="registroModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content bg-dark text-white">
                <form action="${pageContext.request.contextPath}/registrarTarjeta" method="post">
                    <div class="modal-header border-bottom-0">
                        <h5 class="modal-title text-warning" id="registroModalLabel">Registrar Nueva Tarjeta</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="numeroTarjeta" class="form-label">Número de Tarjeta (Simulado):</label>
                            <input type="text" class="form-control bg-secondary text-white" id="numeroTarjeta" name="numeroTarjeta" maxlength="16" placeholder="XXXX XXXX XXXX XXXX" required>
                            <div class="form-text text-muted">Nota: Por seguridad, solo almacenamos los últimos 4 dígitos.</div>
                        </div>
                        <div class="mb-3">
                            <label for="nombreTitular" class="form-label">Nombre del Titular:</label>
                            <input type="text" class="form-control bg-secondary text-white" id="nombreTitular" name="nombreTitular" required>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="fechaExpiracion" class="form-label">Fecha de Expiración (MM/AA):</label>
                                <input type="text" class="form-control bg-secondary text-white" id="fechaExpiracion" name="fechaExpiracion" placeholder="MM/AA" maxlength="5" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="cvv" class="form-label">CVV (Simulado):</label>
                                <input type="text" class="form-control bg-secondary text-white" id="cvv" name="cvv" maxlength="4" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="tipoTarjeta" class="form-label">Tipo:</label>
                                <select class="form-select bg-secondary text-white" id="tipoTarjeta" name="tipoTarjeta" required>
                                    <option value="Visa">Visa</option>
                                    <option value="Mastercard">Mastercard</option>
                                    <option value="Amex">Amex</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="submit" class="btn btn-warning fw-bold">Guardar Tarjeta</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%-- FIN: MODAL DE REGISTRO DE TARJETA --%>
    
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>