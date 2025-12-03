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
                
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Gestionar Productos</h2>
                    <div>
                        <button class="btn btn-outline-light me-2" data-bs-toggle="modal" data-bs-target="#gestionarCategoriasModal">
                            <i class="bi bi-list-ul me-2"></i>Gestionar Categorías
                        </button>
                        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#agregarProductoModal">
                            <i class="bi bi-plus-circle me-2"></i>Nuevo Producto
                        </button>
                    </div>
                </div>
                
                <%-- FILTROS --%>
                <div class="card bg-dark text-white mb-4 border-secondary">
                    <div class="card-body py-3">
                        <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="GET" class="row g-2 align-items-center">
                            <div class="col-md-4">
                                <input type="text" class="form-control bg-secondary text-white border-0" name="busqueda" placeholder="Buscar por nombre..." value="${param.busqueda}">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select bg-secondary text-white border-0" name="categoria">
                                    <option value="0">Todas las Categorías</option>
                                    <c:forEach var="cat" items="${listaCategorias}">
                                        <option value="${cat.id_categoria}" ${param.categoria == cat.id_categoria ? 'selected' : ''}>${cat.nombre_categoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <%-- NUEVO: Filtro Stock --%>
                            <div class="col-md-3">
                                <select class="form-select bg-secondary text-white border-0" name="ordenStock">
                                    <option value="">Ordenar por Stock</option>
                                    <option value="menor_stock" ${param.ordenStock == 'menor_stock' ? 'selected' : ''}>Menor Stock Primero</option>
                                    <option value="mayor_stock" ${param.ordenStock == 'mayor_stock' ? 'selected' : ''}>Mayor Stock Primero</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-info w-100"><i class="bi bi-filter"></i> Filtrar</button>
                            </div>
                        </form>
                    </div>
                </div>
        
                <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
                <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

                <div class="card">
                    <div class="card-body">
                        <table class="table table-dark table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Imagen</th><th>Nombre</th><th>Precio</th><th>Stock</th><th>Estado</th><th>Fecha</th><th class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="prod" items="${listaProductos}">
                                    <tr>
                                        <td>
                                            <c:set var="rutaImg" value="${pageContext.request.contextPath}/img/${prod.imagen}" />
                                            <c:if test="${fn:startsWith(prod.imagen, 'http')}"><c:set var="rutaImg" value="${prod.imagen}" /></c:if>
                                            <img src="${rutaImg}" alt="${prod.nombre}" width="60" style="border-radius: 5px; height: 60px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/60?text=Error'">
                                        </td>
                                        <td>${prod.nombre}</td>
                                        <td><fmt:formatNumber value="${prod.precio}" type="currency" currencySymbol="S/"/></td>
                                        <td>
                                            ${prod.stock}
                                            <%-- ALERTA STOCK BAJO --%>
                                            <c:if test="${prod.stock <= 10}">
                                                <span class="badge bg-danger ms-1" title="Stock Bajo (<10)"><i class="bi bi-exclamation-triangle-fill"></i></span>
                                            </c:if>
                                        </td>
                                        <td><span class="badge ${prod.estado == 'activo' ? 'bg-success' : 'bg-secondary'}">${prod.estado}</span></td>
                                        <td><fmt:formatDate value="${prod.fecha_creacion}" pattern="dd/MM/yyyy"/></td>
                                        <td class="text-end">
                                            <button class="btn btn-sm btn-outline-info edit-btn" title="Editar" data-bs-toggle="modal" data-bs-target="#editarProductoModal" 
                                                    data-id="${prod.id_producto}" data-nombre="${prod.nombre}" data-descripcion="${prod.descripcion}" 
                                                    data-precio="${prod.precio}" data-stock="${prod.stock}" data-id-categoria="${prod.id_categoria}" 
                                                    data-imagen="${prod.imagen}">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post" class="d-inline">
                                                <input type="hidden" name="idProducto" value="${prod.id_producto}">
                                                <input type="hidden" name="action" value="toggle_status">
                                                <c:choose>
                                                    <c:when test="${prod.estado == 'activo'}"><button type="submit" class="btn btn-sm btn-outline-warning" title="Ocultar"><i class="bi bi-eye-slash"></i></button></c:when>
                                                    <c:otherwise><button type="submit" class="btn btn-sm btn-outline-success" title="Mostrar"><i class="bi bi-eye"></i></button></c:otherwise>
                                                </c:choose>
                                            </form>
                                            <button class="btn btn-sm btn-outline-danger delete-btn" title="Eliminar" data-bs-toggle="modal" data-bs-target="#eliminarProductoModal" data-id="${prod.id_producto}">
                                                <i class="bi bi-trash"></i>
                                            </button>
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

    <%-- MODAL GESTIONAR CATEGORÍAS --%>
    <div class="modal fade" id="gestionarCategoriasModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title text-white"><i class="bi bi-tags me-2"></i>Gestionar Categorías</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <%-- Formulario Crear --%>
                    <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post" class="mb-4 border-bottom border-secondary pb-3">
                        <input type="hidden" name="action" value="create_category">
                        <div class="row g-2">
                            <div class="col-md-4"><input type="text" class="form-control bg-dark text-white" name="nombreCat" placeholder="Nombre Categoría" required></div>
                            <div class="col-md-5"><input type="text" class="form-control bg-dark text-white" name="descCat" placeholder="Descripción"></div>
                            <div class="col-md-3"><button type="submit" class="btn btn-success w-100"><i class="bi bi-plus"></i> Crear</button></div>
                        </div>
                    </form>
                    <%-- Lista de Categorías con Editar/Eliminar --%>
                    <div class="table-responsive">
                        <table class="table table-dark table-sm align-middle">
                            <thead><tr><th>ID</th><th>Nombre</th><th>Descripción</th><th class="text-end">Acciones</th></tr></thead>
                            <tbody>
                                <c:forEach var="cat" items="${listaCategorias}">
                                    <tr>
                                        <td>${cat.id_categoria}</td>
                                        <td>${cat.nombre_categoria}</td>
                                        <td>${cat.descripcion}</td>
                                        <td class="text-end">
                                            <%-- Botón Editar abre sub-modal --%>
                                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editarCategoriaModal" 
                                                    data-id="${cat.id_categoria}" data-nombre="${cat.nombre_categoria}" data-desc="${cat.descripcion}">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            
                                            <%-- CAMBIO AQUÍ: Botón que abre el modal en lugar del confirm() --%>
                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#eliminarCategoriaModal"
                                                    data-id="${cat.id_categoria}">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%-- SUB-MODAL EDITAR CATEGORÍA --%>
    <div class="modal fade" id="editarCategoriaModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content" style="background-color: #2b2b2b; border: 1px solid #555;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post">
                    <input type="hidden" name="action" value="update_category">
                    <input type="hidden" name="idCategoria" id="edit-cat-id">
                    <div class="modal-body">
                        <h6 class="text-warning mb-3">Editar Categoría</h6>
                        <div class="mb-2"><input type="text" class="form-control bg-dark text-white" id="edit-cat-nombre" name="nombreCat" required></div>
                        <div class="mb-2"><textarea class="form-control bg-dark text-white" id="edit-cat-desc" name="descCat" rows="2"></textarea></div>
                        <button type="submit" class="btn btn-info w-100 btn-sm">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- NUEVO: SUB-MODAL ELIMINAR CATEGORÍA --%>
    <div class="modal fade" id="eliminarCategoriaModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background-color: #2b2b2b; border: 1px solid #555; color: white;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post">
                    <input type="hidden" name="action" value="delete_category">
                    <input type="hidden" name="idCategoria" id="delete-cat-id">
                    <div class="modal-header border-bottom-0">
                        <h5 class="modal-title text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Eliminar Categoría</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <p class="fs-5">¿Seguro que deseas eliminar esta categoría?</p>
                        <div class="alert alert-warning small border-0 text-dark">
                            <i class="bi bi-info-circle-fill me-1"></i> Si la categoría tiene productos asociados, no se podrá eliminar.
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 justify-content-center">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-danger px-4 fw-bold">Sí, Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="agregarProductoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-warning">Añadir Nuevo Producto</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <div class="mb-3"><label class="form-label">Nombre</label><input type="text" class="form-control bg-dark text-white" name="nombre" required></div>
                        <div class="mb-3"><label class="form-label">Descripción</label><textarea class="form-control bg-dark text-white" name="descripcion" rows="3"></textarea></div>
                        <div class="row"><div class="col-md-6 mb-3"><label class="form-label">Precio (S/)</label><input type="number" step="0.01" class="form-control bg-dark text-white" name="precio" required></div><div class="col-md-6 mb-3"><label class="form-label">Stock</label><input type="number" class="form-control bg-dark text-white" name="stock" required></div></div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label class="form-label">Categoría</label><select class="form-select bg-dark text-white" name="idCategoria" required><option value="">Seleccione</option><c:forEach var="cat" items="${listaCategorias}"><option value="${cat.id_categoria}">${cat.nombre_categoria}</option></c:forEach></select></div>
                            <div class="col-md-6 mb-3"><label class="form-label">URL Imagen (Link)</label><input type="text" class="form-control bg-dark text-white" name="imagen" placeholder="https://..." required></div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0"><button type="submit" class="btn btn-warning">Guardar</button><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editarProductoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post">
                    <input type="hidden" name="action" value="update"><input type="hidden" name="idProductoUpdate" id="edit-id-producto">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-warning">Editar Producto</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <div class="mb-3"><label class="form-label">Nombre</label><input type="text" class="form-control bg-dark text-white" id="edit-nombre" name="nombre" required></div>
                        <div class="mb-3"><label class="form-label">Descripción</label><textarea class="form-control bg-dark text-white" id="edit-descripcion" name="descripcion" rows="3"></textarea></div>
                        <div class="row"><div class="col-md-6 mb-3"><label class="form-label">Precio (S/)</label><input type="number" step="0.01" class="form-control bg-dark text-white" id="edit-precio" name="precio" required></div><div class="col-md-6 mb-3"><label class="form-label">Stock</label><input type="number" class="form-control bg-dark text-white" id="edit-stock" name="stock" required></div></div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label class="form-label">Categoría</label><select class="form-select bg-dark text-white" id="edit-idCategoria" name="idCategoria" required><option value="">Seleccione</option><c:forEach var="cat" items="${listaCategorias}"><option value="${cat.id_categoria}">${cat.nombre_categoria}</option></c:forEach></select></div>
                            <div class="col-md-6 mb-3"><label class="form-label">URL Imagen</label><input type="text" class="form-control bg-dark text-white" id="edit-imagen" name="imagen"></div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0"><button type="submit" class="btn btn-info">Guardar Cambios</button><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="eliminarProductoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background-color: #1f1f1f; border: 1px solid #333;">
                <form action="${pageContext.request.contextPath}/admin/gestionar-productos" method="post">
                    <input type="hidden" name="action" value="delete"><input type="hidden" name="idProducto" id="delete-id-producto">
                    <div class="modal-header border-bottom-0"><h5 class="modal-title text-danger">Confirmar Eliminación</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body"><p>¿Estás seguro de que quieres eliminar este producto?</p><p class="small text-muted">Si tiene ventas asociadas, solo se desactivará.</p></div>
                    <div class="modal-footer border-top-0"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button><button type="submit" class="btn btn-danger">Sí, Eliminar</button></div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Lógica para cargar datos en modal editar producto
            const editarProductoModal = document.getElementById('editarProductoModal');
            if (editarProductoModal) {
                editarProductoModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    document.getElementById('edit-id-producto').value = button.getAttribute('data-id');
                    document.getElementById('edit-nombre').value = button.getAttribute('data-nombre');
                    document.getElementById('edit-descripcion').value = button.getAttribute('data-descripcion');
                    document.getElementById('edit-precio').value = button.getAttribute('data-precio');
                    document.getElementById('edit-stock').value = button.getAttribute('data-stock');
                    document.getElementById('edit-idCategoria').value = button.getAttribute('data-id-categoria');
                    document.getElementById('edit-imagen').value = button.getAttribute('data-imagen');
                });
            }
            
            // Lógica para modal editar categoría
            const editarCategoriaModal = document.getElementById('editarCategoriaModal');
            if (editarCategoriaModal) {
                editarCategoriaModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    document.getElementById('edit-cat-id').value = button.getAttribute('data-id');
                    document.getElementById('edit-cat-nombre').value = button.getAttribute('data-nombre');
                    document.getElementById('edit-cat-desc').value = button.getAttribute('data-desc');
                });
            }
            
            // Lógica para modal eliminar categoría (NUEVO)
            const eliminarCategoriaModal = document.getElementById('eliminarCategoriaModal');
            if (eliminarCategoriaModal) {
                eliminarCategoriaModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    const idCategoria = button.getAttribute('data-id');
                    document.getElementById('delete-cat-id').value = idCategoria;
                });
            }

            const eliminarProductoModal = document.getElementById('eliminarProductoModal');
            if (eliminarProductoModal) {
                eliminarProductoModal.addEventListener('show.bs.modal', function (event) {
                    const button = event.relatedTarget;
                    document.getElementById('delete-id-producto').value = button.getAttribute('data-id');
                });
            }
        });
    </script>
</body>
</html>