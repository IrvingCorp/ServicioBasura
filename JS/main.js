// URL base del backend FastAPI
const API_URL = "http://localhost:8000";

// GET genérico para FastAPI
async function apiGet(endpoint) {
    const res = await fetch(`${API_URL}/${endpoint}`);
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
