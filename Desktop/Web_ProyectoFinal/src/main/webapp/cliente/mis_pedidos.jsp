<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>
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
    <title>Mis Pedidos - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
    <style> .text-golden { color: #c5a059; } </style>
</head>
<body>
    <jsp:include page="/header/header.jsp" />
    <main class="container my-5">
        <div class="row"><div class="col-12 text-center"><h1 class="mb-4 fw-bold">Mis Pedidos</h1><p class="lead text-golden">Revisa el historial y estado de tus compras.</p><hr></div></div>
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-lg border-0 p-4">
                    <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                    <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>
                    <c:choose>
                        <c:when test="${not empty pedidos}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle">
                                    <thead class="table-dark"><tr><th>ID</th><th>Fecha</th><th>Total</th><th>Estado</th><th>Detalle</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="pedido" items="${pedidos}">
                                            <tr>
                                                <td>#${pedido.id_pedido}</td>
                                                <%-- FECHA CORREGIDA --%>
                                                <td><fmt:formatDate value="${pedido.fecha_pedido}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td class="fw-bold">S/ <fmt:formatNumber value="${pedido.total}" pattern="#0.00" /></td>
                                                <td><span class="badge bg-warning text-dark text-uppercase">${pedido.estado}</span></td>
                                                <td><button type="button" class="btn btn-sm btn-outline-dark" data-bs-toggle="modal" data-bs-target="#modalPedido${pedido.id_pedido}"><i class="bi bi-eye"></i> Ver</button></td>
                                            </tr>
                                            <div class="modal fade" id="modalPedido${pedido.id_pedido}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content bg-dark text-white">
                                                        <div class="modal-header border-bottom-0"><h5 class="modal-title text-warning">Detalle del Pedido #${pedido.id_pedido}</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                                                        <div class="modal-body">
                                                            <%-- FECHA EN MODAL CORREGIDA --%>
                                                            <p class="small text-muted mb-3">Fecha: <fmt:formatDate value="${pedido.fecha_pedido}" pattern="dd/MM/yyyy HH:mm" /></p>
                                                            <div class="list-group">
                                                                <c:forEach var="item" items="${pedido.detalles}">
                                                                    <div class="list-group-item bg-secondary text-white border-0 mb-2 rounded d-flex align-items-center">
                                                                        <c:set var="rutaImg" value="${pageContext.request.contextPath}/img/${item.imagen}" />
                                                                        <c:if test="${fn:startsWith(item.imagen, 'http')}"><c:set var="rutaImg" value="${item.imagen}" /></c:if>
                                                                        <img src="${rutaImg}" alt="Prod" style="width: 50px; height: 50px; object-fit: contain;" class="bg-white rounded me-3" onerror="this.src='https://via.placeholder.com/50?text=Err'">
                                                                        <div class="flex-grow-1"><h6 class="mb-0">${item.nombreProducto}</h6><small>Cant: ${item.cantidad} x S/ ${item.precioUnitario}</small></div>
                                                                        <span class="fw-bold">S/ ${item.subtotal}</span>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                            <div class="mt-3 text-end pt-2 border-top border-secondary"><h4 class="text-warning fw-bold">Total: S/ <fmt:formatNumber value="${pedido.total}" pattern="#0.00" /></h4></div>
                                                        </div>
                                                        <div class="modal-footer border-top-0"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise><div class="text-center py-5"><i class="bi bi-box-seam display-4 text-golden"></i><h4 class="mt-3 text-golden">Aún no has realizado ningún pedido.</h4><a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning mt-3">¡Empieza a Comprar!</a></div></c:otherwise>
                    </c:choose>
                    <div class="mt-4 text-center"><a href="${pageContext.request.contextPath}/cliente/cuenta.jsp" class="btn btn-dark"><i class="bi bi-arrow-left me-2"></i>Volver a Mi Intranet</a></div>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>