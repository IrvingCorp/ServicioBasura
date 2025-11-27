
const params = new URLSearchParams(window.location.search);
const rutaId = params.get("id");

document.addEventListener("DOMContentLoaded", async () => {
    const token = localStorage.getItem("token");

    if (!token) {
        alert("No estás autenticado");
        window.location.href = "index.html";
        return;
    }

    // ======================================================
    // 1. Cargar datos de la ruta que vamos a editar
    // ======================================================
    const res = await fetch(`http://127.0.0.1:8000/planificacion/ruta/${rutaId}`, {
        headers: { "Authorization": "Bearer " + token }
    });
    const ruta = await res.json();

    // Rellenar fecha
    document.getElementById("fecha").value = ruta.fecha;


    // ======================================================
    // 2. Cargar camiones
    // ======================================================
    const resCam = await fetch("http://127.0.0.1:8000/camiones", {
        headers: { "Authorization": "Bearer " + token }
    });
    const camiones = await resCam.json();

    let selCam = document.getElementById("camion");
    camiones.forEach(c => {
        let opt = document.createElement("option");
        opt.value = c.id;
        opt.textContent = c.numero_camion;
        if (c.id === ruta.camion_id) opt.selected = true;
        selCam.appendChild(opt);
    });


    // ======================================================
    // 3. Cargar choferes
    // ======================================================
    const resCh = await fetch("http://127.0.0.1:8000/users/choferes", {
        headers: { "Authorization": "Bearer " + token }
    });
    const choferes = await resCh.json();

    let selCh = document.getElementById("chofer");
    choferes.forEach(ch => {
        let opt = document.createElement("option");
        opt.value = ch.id;
        opt.textContent = ch.nombre;
        if (ch.id === ruta.chofer_id) opt.selected = true;
        selCh.appendChild(opt);
    });


    // ======================================================
    // 4. Cargar colonias + seleccionar las asignadas
    // ======================================================
    const resCol = await fetch("http://127.0.0.1:8000/colonias", {
        headers: { "Authorization": "Bearer " + token }
    });
    const colonias = await resCol.json();

    let selCol = document.getElementById("colonias");

    colonias.forEach(col => {
        let opt = document.createElement("option");
        opt.value = col.id;
        opt.textContent = col.nombre_colonia;

        // Aquí se usa ruta.colonias_ids (lista de IDs, no nombres)
        if (ruta.colonias_ids.includes(col.id)) {
            opt.selected = true;
        }

        selCol.appendChild(opt);
    });

});


// ======================================================
// 5. Guardar cambios (PUT)
// ======================================================
async function guardarCambios() {
    const token = localStorage.getItem("token");

    const fecha = document.getElementById("fecha").value;
    const camion = document.getElementById("camion").value;
    const chofer = document.getElementById("chofer").value;

    const cols = Array.from(
        document.getElementById("colonias").selectedOptions
    ).map(o => parseInt(o.value));

    const res = await fetch(`http://127.0.0.1:8000/planificacion/ruta/${rutaId}`, {
        method: "PUT",
        headers: {
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            fecha,
            camion_id: camion,
            chofer_id: chofer,
            colonias: cols
        })
    });

    if (res.ok) {
        alert("Ruta actualizada correctamente");
        window.location.href = "admin.html";
    } else {
        const error = await res.json();
        alert("Error: " + error.detail);
    }
}
