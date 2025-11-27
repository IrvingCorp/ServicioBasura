
// ================================================
//   CARGAR DATOS AL INICIAR LA PÁGINA
// ================================================
document.addEventListener("DOMContentLoaded", async () => {
    const token = localStorage.getItem("token");

    if (!token) {
        alert("No estás autenticado");
        window.location.href = "index.html";
        return;
    }

    await cargarCamiones();
    await cargarChoferes();
    await cargarColonias();
});

// ================================================
//   CARGAR CAMIONES
// ================================================
async function cargarCamiones() {
    const res = await fetch("http://127.0.0.1:8000/camiones/", {
        headers: { "Authorization": "Bearer " + localStorage.getItem("token") }
    });
    const data = await res.json();

    let select = document.getElementById("selectCamion");
    select.innerHTML = "<option value=''>Seleccione un camión</option>";

    data.forEach(c => {
        const opt = document.createElement("option");
        opt.value = c.id;
        opt.textContent = `${c.numero_camion} - ${c.estado}`;
        select.appendChild(opt);
    });
}

// ================================================
//   CARGAR CHOFERES
// ================================================
async function cargarChoferes() {
    const res = await fetch("http://127.0.0.1:8000/usuarios/choferes", {
        headers: { "Authorization": "Bearer " + localStorage.getItem("token") }
    });
    const data = await res.json();

    let select = document.getElementById("selectChofer");
    select.innerHTML = "<option value=''>Seleccione un chofer</option>";

    data.forEach(c => {
        const opt = document.createElement("option");
        opt.value = c.id;
        opt.textContent = c.nombre;
        select.appendChild(opt);
    });
}

// ================================================
//   CARGAR COLONIAS
// ================================================
async function cargarColonias() {
    const res = await fetch("http://127.0.0.1:8000/colonias/", {
        headers: { "Authorization": "Bearer " + localStorage.getItem("token") }
    });
    const data = await res.json();

    let select = document.getElementById("selectColonias");
    select.innerHTML = "";

    data.forEach(col => {
        const opt = document.createElement("option");
        opt.value = col.id;
        opt.textContent = col.nombre;
        select.appendChild(opt);
    });
}

// ================================================
//   GUARDAR PLANIFICACIÓN
// ================================================
async function guardarPlanificacion() {

    const fecha = document.getElementById("inputFecha").value;
    const camion = document.getElementById("selectCamion").value;
    const chofer = document.getElementById("selectChofer").value;

    const coloniasSelect = document.getElementById("selectColonias");
    const colonias = Array.from(coloniasSelect.selectedOptions).map(opt => opt.value);

    if (!fecha || !camion || !chofer || colonias.length === 0) {
        alert("Completa todos los campos");
        return;
    }

    const body = {
        fecha: fecha,
        camion_id: camion,
        chofer_id: chofer,
        colonias: colonias
    };

    const res = await fetch("http://127.0.0.1:8000/planificacion/crear", {
        method: "POST",
        headers: {
            "Authorization": "Bearer " + localStorage.getItem("token"),
            "Content-Type": "application/json"
        },
        body: JSON.stringify(body)
    });

    const data = await res.json();

    if (res.ok) {
        alert("Planificación creada correctamente");
        window.location.href = "admin.html";
    } else {
        alert("Error: " + data.detail);
    }
}
