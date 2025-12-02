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
    <title>Gestionar Clientes - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_layout_style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_dashboard_style.css">
</head>
<body>
    <div class="admin-layout">
        <nav class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard"><img src="${pageContext.request.contextPath}/img/logo_sin_fondo.png" alt="Logo" class="sidebar-logo"></a>
        
            <ul class="nav flex-column">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-productos"><i class="bi bi-box-seam me-2"></i> Gestionar Productos</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-ventas"><i class="bi bi-cart4 me-2"></i> Gestionar Ventas</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/gestionar-clientes"><i class="bi bi-people me-2"></i> Gestionar Clientes</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-admins"><i class="bi bi-person-gear me-2"></i> Gestionar Admins</a></li>
                <hr>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cerrarSesion"><i class="bi bi-box-arrow-left me-2"></i> Cerrar Sesión</a></li>
            </ul>
        </nav>

        <div class="admin-main-content">
            <header class="top-header"></header>
        
            <main class="container-fluid p-4">
                <h2 class="mb-4">Gestionar Clientes</h2>
                
                <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

                <div class="card">
                    <div class="card-body">
                        <table class="table table-dark table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre Completo</th>
                                    <th>Correo</th>
                                    <th>Teléfono</th>
                                    <th>Estado</th>
                                    <th class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty listaUsuarios}">
                                        <c:forEach var="u" items="${listaUsuarios}">
                                            <tr>
                                                <td>${u.id_usuario}</td>
                                                <td>${u.nombre} ${u.apellido}</td>
                                                <td>${u.correo}</td>
                                                <td>${u.telefono}</td>
                                                <td><span class="badge ${u.estado == 'activo' ? 'bg-success' : 'bg-danger'}">${u.estado}</span></td>
                                                <td class="text-end">
                                                    
                                                    <%-- Botón de Ver Detalles como Modal Trigger --%>
                                                    <button class="btn btn-sm btn-outline-info detalle-btn" 
                                                            title="Ver Detalles"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#detalleModal"
                                                            data-nombre="${u.nombre} ${u.apellido}"
                                                            data-correo="${u.correo}"
                                                            data-telefono="${u.telefono}"
                                                            <%-- FIX: Aseguramos que el campo direccion se pase correctamente --%>
                                                            data-direccion="${u.direccion}"
                                                            data-estado="${u.estado}"
                                                            data-id="${u.id_usuario}">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    
                                                    <%-- Formulario para Activar/Desactivar --%>
                                                    <form action="${pageContext.request.contextPath}/admin/gestionar-clientes" method="post" class="d-inline">
                                                        <input type="hidden" name="idUsuario" value="${u.id_usuario}">
                                                        <c:choose>
                                                            <c:when test="${u.estado == 'activo'}">
                                                                <input type="hidden" name="action" value="desactivar">
                                                                <button type="submit" class="btn btn-sm btn-outline-warning" title="Desactivar"><i class="bi bi-person-x"></i></button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="hidden" name="action" value="activar">
                                                                <button type="submit" class="btn btn-sm btn-outline-success" title="Activar"><i class="bi bi-person-check"></i></button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">No hay clientes registrados.</td>
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

    <%-- MODAL DE DETALLE DE USUARIO --%>
    <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333; color: white;">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title text-warning" id="detalleModalLabel">Detalles del Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <dl class="row">
                        <dt class="col-sm-4 text-warning">ID:</dt>
                        <dd class="col-sm-8" id="modal-id"></dd>

                        <dt class="col-sm-4 text-warning">Nombre:</dt>
                        <dd class="col-sm-8" id="modal-nombre"></dd>
                        
                        <dt class="col-sm-4 text-warning">Correo:</dt>
                        <dd class="col-sm-8" id="modal-correo"></dd>
                        
                        <dt class="col-sm-4 text-warning">Teléfono:</dt>
                        <dd class="col-sm-8" id="modal-telefono"></dd>
                        
                        <dt class="col-sm-4 text-warning">Dirección:</dt>
                        <dd class="col-sm-8" id="modal-direccion"></dd>
                        
                        <dt class="col-sm-4 text-warning">Estado:</dt>
                        <dd class="col-sm-8" id="modal-estado"></dd>
                    </dl>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <%-- FIN: MODAL DE DETALLE DE USUARIO --%>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const detalleModal = document.getElementById('detalleModal');
            if (detalleModal) {
                detalleModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget; 
                    
                    // Obtener los datos del cliente desde los atributos del botón
                    const id = button.getAttribute('data-id');
                    const nombre = button.getAttribute('data-nombre');
                    const correo = button.getAttribute('data-correo');
                    const telefono = button.getAttribute('data-telefono');
                    
                    // CORRECCIÓN JS: Leemos la dirección, si es null o 'null' la tratamos como no especificada.
                    let direccion = button.getAttribute('data-direccion'); 
                    if (direccion === 'null' || direccion === null || direccion.trim() === '') {
                        direccion = 'No especificada';
                    }

                    const estado = button.getAttribute('data-estado');

                    // Rellenar los campos del modal
                    document.getElementById('modal-id').textContent = id;
                    document.getElementById('modal-nombre').textContent = nombre;
                    document.getElementById('modal-correo').textContent = correo;
                    document.getElementById('modal-telefono').textContent = telefono;
                    document.getElementById('modal-direccion').textContent = direccion; // Usamos la variable limpia

                    // Rellenar y aplicar estilo al campo Estado
                    const estadoElement = document.getElementById('modal-estado');
                    estadoElement.textContent = estado;
                    estadoElement.className = 'col-sm-8 fw-bold';
                    estadoElement.classList.add(estado === 'activo' ? 'text-success' : 'text-danger');
                });
            }
        });
    </script>
</body>
</html>