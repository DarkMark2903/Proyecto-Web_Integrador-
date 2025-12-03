<%@page import="dao.TarjetaDAO"%>
<%@page import="model.Tarjeta"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuario"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.math.RoundingMode"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    
    BigDecimal subtotal = BigDecimal.ZERO;
    BigDecimal igv = BigDecimal.ZERO;
    BigDecimal costoEnvio = new BigDecimal("15.00");
    BigDecimal totalPagar = BigDecimal.ZERO;

    // Recuperamos el total calculado por el CarritoController
    Object totalObj = request.getAttribute("carritoTotal");
    
    if (totalObj instanceof BigDecimal) {
        subtotal = (BigDecimal) totalObj;
        // Cálculo: IGV es 18% del subtotal
        igv = subtotal.multiply(new BigDecimal("0.18")).setScale(2, RoundingMode.HALF_UP);
        // Total a Pagar = Subtotal + IGV + Envío
        totalPagar = subtotal.add(igv).add(costoEnvio);
    }
    
    // Guardamos este total final en sesión para usarlo al procesar la compra
    session.setAttribute("carritoTotalStr", totalPagar.toString());

    List<Tarjeta> misTarjetas = null;
    if (usuarioLogueado != null) {
        TarjetaDAO tDao = new TarjetaDAO();
        misTarjetas = tDao.obtenerTarjetasPorUsuario(usuarioLogueado.getId_usuario());
    }
    request.setAttribute("misTarjetas", misTarjetas);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Carrito de Compras</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/css/c_style.css" rel="stylesheet">
    <style>
        .cart-item { border-bottom: 1px solid #eee; padding: 15px 0; }
        .cart-img { width: 80px; height: 80px; object-fit: contain; }
        .text-golden { color: #c5a059; }
        .card-option:hover { border-color: #ffc107; cursor: pointer; background-color: #343a40; }
        .card-selected { border: 2px solid #ffc107 !important; background-color: #343a40; }
        #loadingOverlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8); z-index: 9999; display: none;
            justify-content: center; align-items: center; flex-direction: column;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/header/header.jsp" />

    <div id="loadingOverlay">
        <div class="spinner-border text-warning" style="width: 3rem; height: 3rem;" role="status"></div>
        <h4 class="text-white mt-3">Procesando pago seguro...</h4>
    </div>

    <main class="container my-5">
        <h1 class="text-center mb-4 fw-bold">Carrito de Compras</h1>
        
        <c:if test="${not empty sessionScope.mensaje}"><div class="alert alert-success">${sessionScope.mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="mensaje" scope="session"/></c:if>
        <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>

        <c:choose>
            <c:when test="${not empty carrito}">
                <div class="row">
                    <%-- LISTA DE PRODUCTOS --%>
                    <div class="col-lg-8">
                        <div class="card shadow-sm p-4">
                            <c:forEach var="item" items="${carrito}">
                                <div class="row cart-item align-items-center">
                                    <div class="col-md-2">
                                        <%-- Lógica de imagen URL/Local --%>
                                        <c:set var="rutaImg" value="${pageContext.request.contextPath}/img/${item.producto.imagen}" />
                                        <c:if test="${fn:startsWith(item.producto.imagen, 'http')}"><c:set var="rutaImg" value="${item.producto.imagen}" /></c:if>
                                        <img src="${rutaImg}" class="img-fluid rounded cart-img" alt="Prod" onerror="this.src='https://via.placeholder.com/80?text=Error'">
                                    </div>
                                    <div class="col-md-5">
                                        <h5 class="fw-bold">${item.producto.nombre}</h5>
                                        <p class="text-muted small">Costo Unitario: S/ <fmt:formatNumber value="${item.producto.precio}" pattern="#0.00" /></p>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <span class="badge bg-secondary">${item.cantidad}</span>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <h5 class="fw-bold text-warning">S/ <fmt:formatNumber value="${item.subtotal}" pattern="#0.00" /></h5>
                                    </div>
                                    <div class="col-md-1 text-end">
                                        <form action="${pageContext.request.contextPath}/carrito" method="POST">
                                            <input type="hidden" name="idProducto" value="${item.producto.id_producto}">
                                            <input type="hidden" name="accion" value="eliminar">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-dark"><i class="bi bi-arrow-left me-2"></i>Seguir Comprando</a>
                            </div>
                        </div>
                    </div>

                    <%-- RESUMEN DE COSTOS --%>
                    <div class="col-lg-4 mt-4 mt-lg-0">
                        <div class="card shadow-sm p-4 bg-dark text-white">
                            <h4 class="mb-4 text-warning fw-bold">Resumen de Costos</h4>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal (Neto):</span>
                                <span>S/ <fmt:formatNumber value="<%= subtotal %>" pattern="#0.00" /></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>IGV (18%):</span>
                                <span>S/ <fmt:formatNumber value="<%= igv %>" pattern="#0.00" /></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Envío:</span>
                                <span>S/ 15.00</span>
                            </div>
                            <hr class="text-warning">
                            <div class="d-flex justify-content-between mb-4">
                                <h5 class="fw-bold text-warning">TOTAL A PAGAR:</h5>
                                <h5 class="fw-bold text-warning">S/ <fmt:formatNumber value="<%= totalPagar %>" pattern="#0.00" /></h5> 
                            </div>

                            <h5 class="mb-3">Método de Pago</h5>
                            
                            <form id="formCompra" action="${pageContext.request.contextPath}/procesarCompra" method="POST">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="metodoPago" id="pagoTarjeta" value="tarjeta" checked>
                                        <label class="form-check-label" for="pagoTarjeta">Tarjeta de Crédito/Débito</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="metodoPago" id="pagoYape" value="yape">
                                        <label class="form-check-label" for="pagoYape">Yape / Plin</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="metodoPago" id="pagoContraentrega" value="contraentrega">
                                        <label class="form-check-label" for="pagoContraentrega">Pago Contra Entrega</label>
                                    </div>
                                </div>
                                
                                <input type="hidden" name="idTarjetaSeleccionada" id="idTarjetaSeleccionada">
                                <input type="hidden" name="direccionEnvio" id="direccionEnvioFinal">

                                <% if (usuarioLogueado != null) { %>
                                    <button type="button" onclick="iniciarProcesoCompra()" class="btn btn-warning w-100 fw-bold mt-3">FINALIZAR COMPRA</button>
                                <% } else { %>
                                    <p class="text-danger mt-3">Debe iniciar sesión.</p>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-warning w-100 fw-bold mt-2">Iniciar Sesión</a>
                                <% } %>
                            </form>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="bi bi-cart-x display-1 text-golden"></i>
                    <h3 class="mt-3 text-golden">Tu carrito está vacío.</h3>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning btn-lg mt-3">Explorar Catálogo</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    
    <%-- MODAL PAGO --%>
    <div class="modal fade" id="modalPago" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title text-warning"><i class="bi bi-credit-card me-2"></i>Finalizar Compra</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="seccionTarjetas">
                        <h6 class="text-muted mb-3">1. Selecciona tu tarjeta:</h6>
                        <c:choose>
                            <c:when test="${not empty misTarjetas}">
                                <div class="d-grid gap-2 mb-3">
                                    <c:forEach var="tarjeta" items="${misTarjetas}">
                                        <div class="card card-option border-secondary" onclick="seleccionarTarjeta('${tarjeta.id_tarjeta}', this)">
                                            <div class="card-body py-2 px-3 d-flex justify-content-between align-items-center">
                                                <div>
                                                    <i class="bi bi-credit-card-2-front text-warning me-2"></i>
                                                    <span class="fw-bold">**** ${tarjeta.ultimosDigitos}</span>
                                                    <small class="text-muted ms-2">(${tarjeta.tipo})</small>
                                                </div>
                                                <i class="bi bi-check-circle-fill text-success d-none check-icon"></i>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning">No tienes tarjetas guardadas.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <hr class="border-secondary">
                    <div>
                        <h6 class="text-muted mb-2">2. Confirmar Dirección de Envío:</h6>
                        <input type="text" class="form-control bg-secondary text-white border-0" id="inputDireccion" 
                               value="<%= (usuarioLogueado != null && usuarioLogueado.getDireccion() != null) ? usuarioLogueado.getDireccion() : "" %>" 
                               placeholder="Dirección registrada en tu cuenta" readonly>
                        <div class="mt-2 text-end">
                             <a href="${pageContext.request.contextPath}/cliente/editar_info.jsp" class="small text-warning text-decoration-none">
                                <i class="bi bi-pencil-square"></i> Cambiar dirección en mi cuenta
                             </a>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-warning fw-bold" onclick="procesarPago()">
                        <i class="bi bi-lock-fill me-1"></i>Pagar S/ <fmt:formatNumber value="<%= totalPagar %>" pattern="#0.00" />
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%-- MODAL ALERTA --%>
    <div class="modal fade" id="modalAlerta" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content bg-danger text-white text-center">
                <div class="modal-body p-4">
                    <i class="bi bi-exclamation-circle fs-1 mb-3"></i>
                    <p id="mensajeAlerta" class="fw-bold mb-0">Debe seleccionar una opción.</p>
                </div>
                <div class="modal-footer justify-content-center border-0 p-2">
                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Entendido</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let tarjetaSeleccionadaId = null;
        const modalPago = new bootstrap.Modal(document.getElementById('modalPago'));
        const modalAlerta = new bootstrap.Modal(document.getElementById('modalAlerta'));

        function iniciarProcesoCompra() {
            const metodoPago = document.querySelector('input[name="metodoPago"]:checked').value;
            if (metodoPago === 'tarjeta') {
                modalPago.show();
            } else {
                document.getElementById('direccionEnvioFinal').value = document.getElementById('inputDireccion').value;
                simularYEnviar();
            }
        }

        function seleccionarTarjeta(id, elemento) {
            tarjetaSeleccionadaId = id;
            document.querySelectorAll('.card-option').forEach(el => {
                el.classList.remove('card-selected');
                el.querySelector('.check-icon').classList.add('d-none');
            });
            elemento.classList.add('card-selected');
            elemento.querySelector('.check-icon').classList.remove('d-none');
        }

        function procesarPago() {
            if (!tarjetaSeleccionadaId) {
                document.getElementById('mensajeAlerta').innerText = "¡Por favor selecciona una tarjeta!";
                modalPago.hide();
                modalAlerta.show();
                return;
            }
            const direccion = document.getElementById('inputDireccion').value;
            if (!direccion || direccion.trim() === "") {
                document.getElementById('mensajeAlerta').innerText = "No tienes una dirección registrada.";
                modalPago.hide();
                modalAlerta.show();
                return;
            }
            document.getElementById('idTarjetaSeleccionada').value = tarjetaSeleccionadaId;
            document.getElementById('direccionEnvioFinal').value = direccion;
            modalPago.hide();
            simularYEnviar();
        }

        function simularYEnviar() {
            document.getElementById('loadingOverlay').style.display = 'flex';
            setTimeout(() => {
                document.getElementById('formCompra').submit();
            }, 2500);
        }
    </script>
</body>
</html>