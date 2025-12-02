<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

    <div class="logo-container">
        <a href="index.jsp">
            <img src="img/logo_sin_fondo.png" alt="Peruvian&Style Logo" class="logo">
        </a>
    </div>

    <div class="d-flex justify-content-center align-items-center vh-100">
        <div class="card p-4 shadow-lg login-card">
            <h3 class="text-center mb-4">Crear Cuenta</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center">${error}</div>
            </c:if>

            <form method="post" action="registro">
                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Tu nombre" required>
                </div>

                <div class="mb-3">
                    <label for="apellido" class="form-label">Apellido</label>
                    <input type="text" class="form-control" id="apellido" name="apellido" placeholder="Tu apellido" required>
                </div>

                <div class="mb-3">
                    <label for="correo" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="correo" name="correo" placeholder="ejemplo@correo.com" required>
                </div>

                <div class="mb-3">
                    <label for="contrasena" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="********" required>
                </div>

                <div class="mb-3">
                    <label for="celular" class="form-label">Número Celular</label>
                    <input type="tel" class="form-control" id="celular" name="celular" placeholder="987654321">
                </div>

                <div class="mb-3">
                    <label for="direccion" class="form-label">Dirección</label>
                    <input type="text" class="form-control" id="direccion" name="direccion" placeholder="Calle 123, Ciudad">
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-2">Registrarse</button>
                <button type="button" class="btn btn-secondary w-100" onclick="window.location.href='index.jsp'">Ya tengo cuenta</button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>