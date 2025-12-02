document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("loginForm");
    const email = document.getElementById("email");
    const password = document.getElementById("password");
    const alertBox = document.getElementById("alert");

    form.addEventListener("submit", (e) => {
        e.preventDefault();

        // Validaciones
        if (email.value.trim() === "" || password.value.trim() === "") {
            showAlert("⚠️ Por favor complete todos los campos.");
            return;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email.value)) {
            showAlert("⚠️ Ingrese un correo electrónico válido.");
            return;
        }

        if (password.value.length < 6) {
            showAlert("⚠️ La contraseña debe tener al menos 6 caracteres.");
            return;
        }

        // Si pasa todas las validaciones
        showAlert("", false);
        alert("✅ Inicio de sesión exitoso (demo).");
        // Aquí puedes hacer el submit real
        // form.submit();
    });

    function showAlert(message, show = true) {
        if (show) {
            alertBox.textContent = message;
            alertBox.classList.remove("d-none");
        } else {
            alertBox.classList.add("d-none");
        }
    }
});
