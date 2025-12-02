<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FIX 1: Añadir el import para que la clase Usuario sea reconocida --%>
<%@page import="model.Usuario"%>
<fmt:setLocale value="es_PE" />
<%
    // Recuperar el objeto usuario logueado para chequeo de permisos en JSP
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    String correoLogueado = (usuarioLogueado != null) ? usuarioLogueado.getCorreo() : "";
    boolean isSuperAdmin = "admin@peruvianstyle.com".equals(correoLogueado);
%>

<c:if test="${empty sessionScope.usuario or sessionScope.usuario.rol != 'admin'}">
    <c:redirect url="${pageContext.request.contextPath}/index.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestionar Administradores - Admin</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/gestionar-clientes"><i class="bi bi-people me-2"></i> Gestionar Clientes</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/gestionar-admins"><i class="bi bi-person-gear me-2"></i> Gestionar Admins</a></li>
                <hr>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cerrarSesion"><i class="bi bi-box-arrow-left me-2"></i> Cerrar Sesión</a></li>
            </ul>
        </nav>

        <div class="admin-main-content">
            <header class="top-header"></header>
        
            <main class="container-fluid p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Gestionar Administradores y Empleados</h2>
                    
                    <%-- FIX: Botón visible solo para Super Admin --%>
                    <% if (isSuperAdmin) { %>
                        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#agregarAdminModal"><i class="bi bi-person-plus-fill me-2"></i>Añadir Nuevo Admin</button>
                    <% } %>
                </div>
                
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
                                    <th>Rol</th>
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
                                                <td><span class="badge bg-info text-dark">${u.rol}</span></td>
                                                <td><span class="badge ${u.estado == 'activo' ? 'bg-success' : 'bg-danger'}">${u.estado}</span></td>
                                                <td class="text-end">
                                                    
                                                    <%-- Formulario para Activar/Desactivar --%>
                                                    <form action="${pageContext.request.contextPath}/admin/gestionar-admins" method="post" class="d-inline">
                                                        <input type="hidden" name="idUsuario" value="${u.id_usuario}">
                                                        <c:choose>
                                                            <c:when test="${u.estado == 'activo'}">
                                                                <input type="hidden" name="action" value="desactivar">
                                                                <%-- Deshabilitar si es el usuario logueado --%>
                                                                <button type="submit" class="btn btn-sm btn-outline-warning" title="Desactivar" ${sessionScope.usuario.id_usuario == u.id_usuario ? 'disabled' : ''}><i class="bi bi-person-x"></i></button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="hidden" name="action" value="activar">
                                                                <button type="submit" class="btn btn-sm btn-outline-success" title="Activar"><i class="bi bi-person-check"></i></button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                    
                                                    <%-- FIX: Lógica de Eliminación Permanente con JSTL --%>
                                                    <%-- Condición: 1. Debe ser Super Admin Y 2. NO debe ser el usuario logueado --%>
                                                    <c:if test="${(sessionScope.usuario.correo eq 'admin@peruvianstyle.com') and (sessionScope.usuario.id_usuario != u.id_usuario)}">
                                                        <button class="btn btn-sm btn-outline-danger delete-btn" title="Eliminar Permanentemente" data-bs-toggle="modal" data-bs-target="#eliminarAdminModal" data-id="${u.id_usuario}"><i class="bi bi-trash"></i></button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">No hay administradores registrados.</td>
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
    
    <%-- MODAL DE ELIMINACIÓN DE ADMIN --%>
    <div class="modal fade" id="eliminarAdminModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-admins" method="post">
                    <input type="hidden" name="action" value="delete_permanent">
                    <input type="hidden" name="idUsuario" id="delete-id-admin">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-danger" id="deleteModalLabel"><i class="bi bi-exclamation-triangle-fill me-2"></i> Confirmar Eliminación</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
                    <div class="modal-body"><p class="text-white">¿Estás seguro de que quieres eliminar este usuario permanentemente? Esta acción es irreversible y requiere que no haya registros dependientes.</p></div>
                    <div class="modal-footer border-top-0"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button><button type="submit" class="btn btn-danger">Sí, Eliminar</button></div>
                </form>
            </div>
        </div>
    </div>
    
    <%-- MODAL DE AGREGAR NUEVO ADMIN --%>
    <div class="modal fade" id="agregarAdminModal" tabindex="-1" aria-labelledby="addAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/crear-admin" method="post">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-warning" id="addAdminModalLabel">Añadir Nuevo Admin/Empleado</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3"><label for="add-nombre" class="form-label">Nombre</label><input type="text" class="form-control bg-dark text-white" name="nombre" required></div>
                            <div class="col-md-6 mb-3"><label for="add-apellido" class="form-label">Apellido</label><input type="text" class="form-control bg-dark text-white" name="apellido" required></div>
                        </div>
                        <div class="mb-3"><label for="add-correo" class="form-label">Correo Electrónico</label><input type="email" class="form-control bg-dark text-white" name="correo" required></div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label for="add-contrasena" class="form-label">Contraseña</label><input type="password" class="form-control bg-dark text-white" name="contrasena" required></div>
                            <div class="col-md-6 mb-3"><label for="add-telefono" class="form-label">Teléfono</label><input type="text" class="form-control bg-dark text-white" name="telefono"></div>
                        </div>
                        <div class="mb-3">
                            <label for="add-rol" class="form-label">Rol</label>
                            <select class="form-select bg-dark text-white" name="rol" required>
                                <option value="admin">Administrador</option>
                                <option value="empleado">Empleado</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="submit" class="btn btn-warning">Crear Administrador</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const eliminarAdminModal = document.getElementById('eliminarAdminModal');
            if (eliminarAdminModal) {
                eliminarAdminModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    const id = button.getAttribute('data-id');
                    document.getElementById('delete-id-admin').value = id;
                });
            }
        });
    </script>
</body>
</html>