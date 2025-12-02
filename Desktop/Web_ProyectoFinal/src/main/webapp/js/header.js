document.addEventListener("DOMContentLoaded", function () {
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const hamburgerMenu = document.getElementById('hamburgerMenu');

    if (hamburgerBtn && hamburgerMenu) {
        hamburgerBtn.addEventListener('click', () => {
            if (hamburgerMenu.style.display === 'flex') {
                hamburgerMenu.style.display = 'none';
            } else {
                hamburgerMenu.style.display = 'flex';
                hamburgerMenu.style.flexDirection = 'column';
            }
        });

        // Cerrar si se hace click fuera del menú
        document.addEventListener('click', function (event) {
            if (!hamburgerMenu.contains(event.target) && !hamburgerBtn.contains(event.target)) {
                hamburgerMenu.style.display = 'none';
            }
        });
    }
});
