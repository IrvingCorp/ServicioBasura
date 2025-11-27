// URL base del backend PHP
const API_URL = "../admin";

// GET genérico
async function apiGet(endpoint) {
    const res = await fetch(`${API_URL}/${endpoint}.php`);
    return await res.json();
}

// POST genérico
async function apiPost(endpoint, data) {
    const res = await fetch(`${API_URL}/${endpoint}.php`, {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(data)
    });
    return await res.json();
}

// Render helper para tablas
function renderTable(containerId, data, columns) {
    const container = document.getElementById(containerId);
    container.innerHTML = `
        <table>
            <thead>
                <tr>${columns.map(c => `<th>${c.label}</th>`).join("")}</tr>
            </thead>
            <tbody>
            ${
                data.map(row => `
                    <tr>
                    ${columns.map(c => `<td>${row[c.field]}</td>`).join("")}
                    </tr>
                `).join("")
            }
            </tbody>
        </table>
    `;
}
