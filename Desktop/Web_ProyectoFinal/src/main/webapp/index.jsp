<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Peruvian&Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="css/login.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="style-footer.css" rel="stylesheet">
</head>
<body>

<%
String correoRecordado = "";
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("correoRecordado".equals(c.getName())) {
            correoRecordado = c.getValue();
        }
    }
}
%>

<div class="logo-container text-center my-3">
    <a href="inicio.jsp">
        <img src="img/logo_sin_fondo.png" alt="Peruvian&Style Logo" class="logo">
    </a>
</div>

<div class="d-flex justify-content-center align-items-center vh-100">
    <div class="card p-4 shadow-lg login-card">
        <h3 class="text-center mb-4">Iniciar Sesión</h3>

        <% 
        if (request.getAttribute("error") != null) { 
        %>
            <div class="alert alert-danger text-center"><%= request.getAttribute("error") %></div>
        <% } %>

        <%
        String mensajeURL = request.getParameter("mensaje");
        if (mensajeURL != null && !mensajeURL.isEmpty()) {
        %>
            <div class="alert alert-success text-center"><%= mensajeURL %></div>
        <% } %>


        <form method="post" action="login">
            <div class="mb-3">
                <label for="correo" class="form-label">Correo Electrónico</label>
                <input type="email" class="form-control" id="correo" name="correo"
                       placeholder="ejemplo@correo.com"
                       value="<%= correoRecordado %>"
                       required>
            </div>

            <div class="mb-3">
                <label for="contrasena" class="form-label">Contraseña</label>
                <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="********" required>
            </div>

            <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="recordar" name="recordar">
                <label class="form-check-label" for="recordar">Recuérdame</label>
            </div>

            <button type="submit" class="btn btn-primary w-100 mb-2">Iniciar Sesión</button>
            <button type="button" class="btn btn-secondary w-100" onclick="window.location.href='registro.jsp'">
                ¿No tienes cuenta? Regístrate
            </button>
        </form>
    </div>
</div>

<script src="js/login.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>