<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="es_PE" />

<c:if test="${empty sessionScope.usuario or (sessionScope.usuario.rol != 'admin' and sessionScope.usuario.rol != 'empleado')}">
    <c:redirect url="${pageContext.request.contextPath}/index.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestionar Ventas - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_layout_style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_dashboard_style.css">
</head>
<body>
    <div class="admin-layout">
        <nav class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard"><img 
            src="${pageContext.request.contextPath}/img/logo_sin_fondo.png" alt="Logo" class="sidebar-logo"></a>
        
            <ul class="nav flex-column">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-productos"><i class="bi bi-box-seam me-2"></i> Gestionar Productos</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/gestionar-ventas"><i class="bi bi-cart4 me-2"></i> Gestionar Ventas</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-clientes"><i class="bi bi-people me-2"></i> Gestionar Clientes</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-admins"><i class="bi bi-person-gear me-2"></i> Gestionar Admins</a></li>
                <hr>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cerrarSesion"><i class="bi bi-box-arrow-left me-2"></i> Cerrar Sesión</a></li>
            </ul>
        </nav>

        <div class="admin-main-content">
            <header class="top-header"></header>
        
            <main class="container-fluid p-4">
                <h2 class="mb-4">Gestionar Ventas</h2>
    
                <div class="card">
                    <div class="card-body">
                        <table class="table table-dark table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID Pedido</th>
                                    <th>Cliente</th>
                                    <th>Fecha</th>
                                    <th>Total</th>
                                    <th>Estado</th>
                                    <th class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty listaPedidos}">
                                        <c:forEach var="pedido" items="${listaPedidos}">
                                            <tr>
                                                <td>#${pedido.id_pedido}</td>
                                                <td>${pedido.nombreCliente}</td>
                                                <td><fmt:formatDate value="${pedido.fecha_pedido}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td class="fw-bold text-warning">S/ <fmt:formatNumber value="${pedido.total}" pattern="#0.00" /></td>
                                                <td>
                                                    <span class="badge ${pedido.estado == 'pagado' ? 'bg-success' : 'bg-secondary'} text-uppercase">
                                                        ${pedido.estado}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <%-- Botón para abrir modal con ID dinámico --%>
                                                    <button class="btn btn-sm btn-outline-info" data-bs-toggle="modal" data-bs-target="#modalVenta${pedido.id_pedido}">
                                                        <i class="bi bi-eye"></i> Ver Detalle
                                                    </button>
                                                </td>
                                            </tr>

                                            <%-- MODAL DE DETALLE (Uno por cada pedido) --%>
                                            <div class="modal fade text-dark" id="modalVenta${pedido.id_pedido}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                                    <div class="modal-content" style="background-color: #2b2b2b; color: #fff;">
                                                        <div class="modal-header border-bottom-0">
                                                            <h5 class="modal-title text-warning">Detalle del Pedido #${pedido.id_pedido}</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <p><strong>Cliente:</strong> ${pedido.nombreCliente}</p>
                                                                </div>
                                                                <div class="col-md-6 text-end">
                                                                    <p><strong>Fecha:</strong> <fmt:formatDate value="${pedido.fecha_pedido}" pattern="dd/MM/yyyy HH:mm" /></p>
                                                                </div>
                                                            </div>

                                                            <h6 class="border-bottom border-secondary pb-2 mb-3">Productos:</h6>
                                                            <div class="list-group mb-3">
                                                                <c:set var="subtotalCalc" value="0" />
                                                                <c:forEach var="item" items="${pedido.detalles}">
                                                                    <div class="list-group-item bg-secondary text-white border-0 mb-2 rounded d-flex align-items-center">
                                                                        <%-- FIX IMAGEN: Si falla, carga default.png --%>
                                                                        <img src="${pageContext.request.contextPath}/img/${item.imagen}" 
                                                                             onerror="this.src='${pageContext.request.contextPath}/img/default.png'"
                                                                             alt="Prod" style="width: 50px; height: 50px; object-fit: contain;" class="bg-white rounded me-3">
                                                                        <div class="flex-grow-1">
                                                                            <h6 class="mb-0">${item.nombreProducto}</h6>
                                                                            <small>Cant: ${item.cantidad} x S/ ${item.precioUnitario}</small>
                                                                        </div>
                                                                        <span class="fw-bold">S/ ${item.subtotal}</span>
                                                                        <c:set var="subtotalCalc" value="${subtotalCalc + item.subtotal}" />
                                                                    </div>
                                                                </c:forEach>
                                                            </div>

                                                            <div class="border-top border-secondary pt-2">
                                                                <div class="d-flex justify-content-between small text-muted">
                                                                    <span>Subtotal:</span>
                                                                    <span>S/ <fmt:formatNumber value="${subtotalCalc}" pattern="#0.00" /></span>
                                                                </div>
                                                                <div class="d-flex justify-content-between small text-muted">
                                                                    <span>IGV (18%):</span>
                                                                    <span>S/ <fmt:formatNumber value="${subtotalCalc * 0.18}" pattern="#0.00" /></span>
                                                                </div>
                                                                <div class="d-flex justify-content-between small text-muted">
                                                                    <span>Envío:</span>
                                                                    <span>S/ 15.00</span>
                                                                </div>
                                                                <div class="d-flex justify-content-between mt-2">
                                                                    <h4 class="text-warning fw-bold">Total Pagado:</h4>
                                                                    <h4 class="text-warning fw-bold">S/ <fmt:formatNumber value="${pedido.total}" pattern="#0.00" /></h4>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer border-top-0">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <%-- Fin Modal --%>

                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">No hay ventas registradas.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>