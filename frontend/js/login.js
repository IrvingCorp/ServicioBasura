document.addEventListener("DOMContentLoaded", () => {

    const form = document.getElementById("loginForm");

    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();

        const result = await login(email, password);

        if (result.error) {
            document.getElementById("errorBox").style.display = "block";
        } else {
            window.location.href = "admin.html";
        }
    });

});
