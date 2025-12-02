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
    <title>Gestionar Productos - Admin</title>
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/gestionar-productos"><i class="bi bi-box-seam me-2"></i> Gestionar Productos</a></li>
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Gestionar Productos</h2>
                    <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#agregarProductoModal"><i class="bi bi-plus-circle me-2"></i>Añadir Nuevo Producto</button>
                </div>
        
                
                <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>


                <div class="card">
                    <div class="card-body">
                        <table class="table table-dark table-hover align-middle">
                          
                            <thead>
                                <tr>
                                    <th>Imagen</th><th>Nombre</th><th>Precio</th><th>Stock</th><th>Estado</th><th>Fecha Creación</th><th class="text-end">Acciones</th>
                            
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="prod" items="${listaProductos}">
                                    <c:set var="imagenSrc" value="${not empty prod.imagen ? prod.imagen : 'default.png'}"/>
                                    <tr>
                                        <%-- RUTA ESTÁTICA CORREGIDA: Apunta a /img/nombre.ext --%>
                                        <td><img src="${pageContext.request.contextPath}/img/${imagenSrc}" alt="${prod.nombre}" width="60" style="border-radius: 5px;"></td>
                                        <td>${prod.nombre}</td>
                                        <td><fmt:formatNumber value="${prod.precio}" type="currency" currencySymbol="S/"/></td>
           
                                        <td>${prod.stock}</td>
                                        <td><span class="badge ${prod.estado == 'activo' ? 'bg-success' : 'bg-secondary'}">${prod.estado}</span></td>
                                        <td><fmt:formatDate value="${prod.fecha_creacion}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="text-end">
              
                                            <button class="btn btn-sm btn-outline-info edit-btn" title="Editar" data-bs-toggle="modal" data-bs-target="#editarProductoModal" data-id="${prod.id_producto}" data-nombre="${prod.nombre}" data-descripcion="${prod.descripcion}" data-precio="${prod.precio}" data-stock="${prod.stock}" data-id-categoria="${prod.id_categoria}"><i class="bi bi-pencil"></i></button>
                                            
                                            <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post" class="d-inline">
                                                <input type="hidden" name="idProducto" value="${prod.id_producto}">
                                                <input type="hidden" name="action" value="toggle_status">
                                                
                                                <c:choose>
                                                    <%-- Si está ACTIVO, muestra OCULTAR --%>
                                                    <c:when test="${prod.estado == 'activo'}">
                                                        <button type="submit" class="btn btn-sm btn-outline-warning" title="Ocultar (Inactivar)"><i class="bi bi-eye-slash"></i></button>
                                                    </c:when>
                                                    <%-- Si está INACTIVO, muestra MOSTRAR --%>
                                                    <c:otherwise>
                                                        <button type="submit" class="btn btn-sm btn-outline-success" title="Mostrar (Activar)"><i class="bi bi-eye"></i></button>
                                                    </c:otherwise>
                                                </c:choose>
                                     
                                            </form>
                                            
                                            <%-- Botón Eliminar Permanente (Solo si el estado es INACTIVO) --%>
                                            <button class="btn btn-sm btn-outline-danger delete-btn" title="Eliminar Permanentemente" data-bs-toggle="modal" data-bs-target="#eliminarProductoModal" data-id="${prod.id_producto}" ${prod.estado == 'activo' ? 'disabled' : ''}><i class="bi bi-trash"></i></button>
                                        </td>
                                    </tr>
                    
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                
                </div>
            </main>
        </div>
    </div>

    <div class="modal fade" id="agregarProductoModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post" enctype="multipart/form-data">
                 
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-warning" id="addModalLabel">Añadir Nuevo Producto</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
                    <div class="modal-body">
                        <div class="mb-3"><label for="nombre" class="form-label">Nombre</label><input type="text" class="form-control bg-dark text-white" name="nombre" required></div>
        
                        <div class="mb-3"><label for="descripcion" class="form-label">Descripción</label><textarea class="form-control bg-dark text-white" name="descripcion" rows="3"></textarea></div>
                        <div class="row"><div class="col-md-6 mb-3"><label for="precio" class="form-label">Precio (S/)</label><input type="number" step="0.01" class="form-control bg-dark text-white" name="precio" required></div><div class="col-md-6 mb-3"><label for="stock" class="form-label">Stock</label><input type="number" class="form-control bg-dark text-white" name="stock" required></div></div>
                        <div class="row"><div class="col-md-6 mb-3"><label for="idCategoria" 
class="form-label">Categoría</label><select class="form-select bg-dark text-white" name="idCategoria" required><option value="">Seleccione</option><c:forEach var="cat" items="${listaCategorias}"><option value="${cat.id_categoria}">${cat.nombre_categoria}</option></c:forEach></select></div><div class="col-md-6 mb-3"><label for="imagen" class="form-label">Imagen</label><input type="file" class="form-control bg-dark text-white" name="imagen" accept="image/png, image/jpeg"></div></div>
                    </div>
                    <div class="modal-footer border-top-0"><button type="submit" class="btn btn-warning">Guardar Producto</button><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button></div>
                </form>
            </div>
  
        </div>
    </div>
    
    <div class="modal fade" id="editarProductoModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f;
border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update"><input type="hidden" name="idProductoUpdate" id="edit-id-producto">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-warning" id="editModalLabel">Editar Producto</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
                    <div 
class="modal-body">
                        <div class="mb-3"><label for="edit-nombre" class="form-label">Nombre</label><input type="text" class="form-control bg-dark text-white" id="edit-nombre" name="nombre" required></div>
                        <div class="mb-3"><label for="edit-descripcion" class="form-label">Descripción</label><textarea class="form-control bg-dark text-white" id="edit-descripcion" name="descripcion" rows="3"></textarea></div>
                        <div class="row"><div class="col-md-6 mb-3"><label for="edit-precio" class="form-label">Precio (S/)</label><input type="number" step="0.01" 
class="form-control bg-dark text-white" id="edit-precio" name="precio" required></div><div class="col-md-6 mb-3"><label for="edit-stock" class="form-label">Stock</label><input type="number" class="form-control bg-dark text-white" id="edit-stock" name="stock" required></div></div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label for="edit-idCategoria" class="form-label">Categoría</label><select class="form-select bg-dark text-white" id="edit-idCategoria" name="idCategoria" required><option value="">Seleccione</option><c:forEach var="cat" items="${listaCategorias}"><option value="${cat.id_categoria}">${cat.nombre_categoria}</option></c:forEach></select></div>
                 
                            <div class="col-md-6 mb-3"><label for="edit-imagen" class="form-label">Cambiar Imagen (Opcional)</label><input type="file" class="form-control bg-dark text-white" id="edit-imagen" name="imagen" accept="image/png, image/jpeg"></div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
         
                        <button type="submit" class="btn btn-info">Guardar Cambios</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </form>
            </div>
     
        </div>
    </div>

    <div class="modal fade" id="eliminarProductoModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f;
border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="idProducto" id="delete-id-producto">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-danger" id="deleteModalLabel"><i class="bi bi-exclamation-triangle-fill me-2"></i> Confirmar Eliminación</h5><button type="button" class="btn-close 
btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
                    <div class="modal-body"><p>¿Estás seguro de que quieres eliminar este producto permanentemente? Esta acción es irreversible.</p></div>
                    <div class="modal-footer border-top-0"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button><button type="submit" class="btn btn-danger">Sí, Eliminar</button></div>
                </form>
            </div>
       
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Script para el modal de EDICIÓN
            const editarProductoModal = document.getElementById('editarProductoModal');
if (editarProductoModal) {
                editarProductoModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    const id = button.getAttribute('data-id');
                    const nombre = button.getAttribute('data-nombre');
          
                    const descripcion = button.getAttribute('data-descripcion');
                    const precio = button.getAttribute('data-precio');
                    const stock = button.getAttribute('data-stock');
                    const idCategoria = button.getAttribute('data-id-categoria');
                  
    
                    document.getElementById('edit-id-producto').value = id;
                    document.getElementById('edit-nombre').value = nombre;
                    document.getElementById('edit-descripcion').value = descripcion;
                    document.getElementById('edit-precio').value = precio;
          
                    document.getElementById('edit-stock').value = stock;
                    document.getElementById('edit-idCategoria').value = idCategoria;
                    document.getElementById('edit-imagen').value = '';
 // Limpiar campo de archivo
                });
}

            // Script para el modal de ELIMINACIÓN
            const eliminarProductoModal = document.getElementById('eliminarProductoModal');
if (eliminarProductoModal) {
                eliminarProductoModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    const id = button.getAttribute('data-id');
                    const idInput = document.getElementById('delete-id-producto');
          
                    idInput.value = id;
                });
}
        });
    </script>
</body>
</html>