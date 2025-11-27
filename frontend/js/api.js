async function login(email, password) {
    const formData = new URLSearchParams();
    formData.append("username", email);
    formData.append("password", password);

    const res = await fetch("http://127.0.0.1:8000/auth/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formData
    });

    if (!res.ok) {
        return { error: true };
    }

    const data = await res.json();
    localStorage.setItem("token", data.access_token);

    return { error: false };
}
