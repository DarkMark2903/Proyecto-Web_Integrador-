<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="es_PE" />

<c:if test="${empty sessionScope.usuario or (sessionScope.usuario.rol != 'admin' and sessionScope.usuario.rol != 'empleado')}">
    <c:redirect url="${pageContext.request.contextPath}/index.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Administrador - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_layout_style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_dashboard_style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="admin-layout">
         <nav class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard"><img src="${pageContext.request.contextPath}/img/logo_sin_fondo.png" alt="Logo" class="sidebar-logo"></a>
            <ul class="nav flex-column">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-productos"><i class="bi bi-box-seam me-2"></i> Gestionar Productos</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-ventas"><i class="bi bi-cart4 me-2"></i> Gestionar Ventas</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-clientes"><i class="bi bi-people me-2"></i> Gestionar Clientes</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-admins"><i class="bi bi-person-gear me-2"></i> Gestionar Admins</a></li>
                <hr>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cerrarSesion"><i class="bi bi-box-arrow-left me-2"></i> Cerrar Sesión</a></li>
            </ul>
        </nav>

        <div class="admin-main-content">
            <header class="top-header"></header>
            <main class="container-fluid p-4">
                <h2 class="mb-1">Panel de Administrador</h2>
                <p class="text-white mb-4">Bienvenido, ${sessionScope.usuario.nombre}.</p>

                <div class="row">
                    <div class="col-xl-3 col-md-6"><div class="card kpi-card kpi-1"><div class="card-body"><div><h3 class="display-5">${kpiProductos}</h3><p>Productos</p></div><i class="bi bi-box-seam"></i></div></div></div>
                    <div class="col-xl-3 col-md-6"><div class="card kpi-card kpi-2"><div class="card-body"><div><h3 class="display-5">${kpiVentas}</h3><p>Ventas Hoy</p></div><i class="bi bi-cart4"></i></div></div></div>
                    <div class="col-xl-3 col-md-6"><div class="card kpi-card kpi-3"><div class="card-body"><div><h3 class="display-5">${kpiClientes}</h3><p>Clientes Activos</p></div><i class="bi bi-people"></i></div></div></div>
                    <div class="col-xl-3 col-md-6"><div class="card kpi-card kpi-4"><div class="card-body"><div><h3 class="display-5"><fmt:formatNumber value="${kpiIngresos}" type="currency" currencySymbol="S/ "/></h3><p>Ingresos Hoy</p></div><i class="bi bi-cash-stack"></i></div></div></div>
                </div>

                <div class="row mt-4">
                    <div class="col-lg-8 mb-4">
                        <div class="card h-100">
                            <div class="card-header">Ventas de los últimos 7 días</div>
                            <div class="card-body"><canvas id="ventasChart"></canvas></div>
                        </div>
                    </div>
                    <div class="col-lg-4 mb-4">
                        <div class="card h-100">
                            <div class="card-header">Clientes Recientes</div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
                                    <c:forEach var="cliente" items="${clientesRecientes}">
                                      <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <div><strong>${cliente.nombre} ${cliente.apellido}</strong><br><small class="text-muted">${cliente.correo}</small></div>
                                            <span class="badge ${cliente.estado == 'activo' ? 'bg-success' : 'bg-danger'}">${cliente.estado}</span>
                                        </li>
                                    </c:forEach>
                               </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <%-- TÍTULO ACTUALIZADO --%>
                            <div class="card-header bg-warning text-dark fw-bold">
                                <i class="bi bi-star-fill me-2"></i> Productos Más Vendidos (Histórico)
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-dark table-striped mb-0 align-middle">
                                        <thead>
                                            <tr>
                                                <th>Imagen</th>
                                                <th>Producto</th>
                                                <th>Precio</th>
                                                <th>Stock Actual</th>
                                                <th>Acción</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty productosTop}">
                                                    <c:forEach var="p" items="${productosTop}">
                                                        <tr>
                                                            <td>
                                                                <c:set var="rutaImg" value="${pageContext.request.contextPath}/img/${p.imagen}" />
                                                                <c:if test="${fn:startsWith(p.imagen, 'http')}"><c:set var="rutaImg" value="${p.imagen}" /></c:if>
                                                                <img src="${rutaImg}" alt="Prod" width="50" height="50" style="object-fit: cover; border-radius: 5px;">
                                                            </td>
                                                            <td class="fw-bold">${p.nombre}</td>
                                                            <td>S/ <fmt:formatNumber value="${p.precio}" pattern="#0.00"/></td>
                                                            <td>
                                                                ${p.stock} 
                                                                <c:if test="${p.stock <= 10}"><span class="badge bg-danger ms-2">Bajo</span></c:if>
                                                            </td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/admin/gestionar-productos" class="btn btn-sm btn-outline-light">Gestionar</a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr><td colspan="5" class="text-center text-muted">No hay datos suficientes de ventas.</td></tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
            </main>
        </div>
    </div>

    <script>
        const datosVentas = [
            <c:forEach var="dato" items="${requestScope.ventas7Dias}" varStatus="status">
                ${dato}${!status.last ? ',' : ''}
            </c:forEach>
        ];
        new Chart(document.getElementById('ventasChart'), {
            type: 'bar',
            data: { 
                labels: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'], 
                datasets: [{ label: 'Ventas (S/)', data: datosVentas, backgroundColor: '#ffc107', borderRadius: 5 }] 
            },
            options: { scales: { y: { beginAtZero: true, ticks: { color: '#e0e0e0' }, grid: { color: '#333' } }, x: { ticks: { color: '#e0e0e0' }, grid: { color: '#333' } } }, plugins: { legend: { labels: { color: '#e0e0e0' } } } }
        });
    </script>
</body>
</html>