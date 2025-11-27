
// ============================
//   DATOS DE DEMO (FRONT)
// ============================
const INITIAL_DATA = {
  users: [
    {
      id: 1,
      nombre: "Admin Principal",
      email: "admin@sc.gob.mx",
      password: "123456",
      rol: "admin",
    },
    {
      id: 2,
      nombre: "Juan Pérez",
      email: "juan.chofer@sc.gob.mx",
      password: "123456",
      rol: "chofer",
    },
    {
      id: 3,
      nombre: "María López",
      email: "maria.chofer@sc.gob.mx",
      password: "123456",
      rol: "chofer",
    },
  ],
  camiones: [
    { id: 1, numero: "CAM-01", estado: "operativo" },
    { id: 2, numero: "CAM-02", estado: "operativo" },
    { id: 3, numero: "CAM-03", estado: "reparacion" },
  ],
  colonias: [
    { id: 1, nombre: "Colonia Centro" },
    { id: 2, nombre: "Colonia San Miguel" },
    { id: 3, nombre: "Colonia Las Flores" },
    { id: 4, nombre: "Colonia Hidalgo" },
    { id: 5, nombre: "Colonia El Mirador" },
  ],
  incidencias: [
    {
      id: 1,
      hora: "08:15",
      camion: "CAM-01",
      chofer: "Juan Pérez",
      tipo: "Bloqueo",
      colonia: "Colonia Centro",
      descripcion: "Calle cerrada por obras.",
    },
  ],
  rutas: [
    // ejemplo se llenará abajo en initDemoRoutes si no hay
  ],
};

const STORAGE_KEY = "demoRecoleccionData";
const STORAGE_USER = "demoCurrentUser";
const STORAGE_EDIT_ROUTE = "demoRutaEditId";

function loadDemoData() {
  const raw = localStorage.getItem(STORAGE_KEY);
  if (raw) return JSON.parse(raw);

  // Primera vez, guardamos datos iniciales
  const data = { ...INITIAL_DATA };
  // Rutas demo básicas
  const today = new Date();
  const todayStr = today.toISOString().slice(0, 10);
  data.rutas = [
    {
      id: 1,
      fecha: todayStr,
      camionId: 1,
      choferId: 2,
      coloniasIds: [1, 2],
      estado: "Planeada",
    },
    {
      id: 2,
      fecha: todayStr,
      camionId: 2,
      choferId: 3,
      coloniasIds: [3, 4, 5],
      estado: "Planeada",
    },
  ];
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  return data;
}

function saveDemoData(data) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
}

function getCurrentUser() {
  const raw = localStorage.getItem(STORAGE_USER);
  if (!raw) return null;
  return JSON.parse(raw);
}

function setCurrentUser(user) {
  if (!user) {
    localStorage.removeItem(STORAGE_USER);
  } else {
    localStorage.setItem(STORAGE_USER, JSON.stringify(user));
  }
}

function formatFecha(fechaStr) {
  const d = new Date(fechaStr);
  if (Number.isNaN(d.getTime())) return fechaStr;
  return d.toLocaleDateString("es-MX", { day: "2-digit", month: "2-digit", year: "numeric" });
}

function diaSemana(fechaStr) {
  const d = new Date(fechaStr);
  return d.toLocaleDateString("es-MX", { weekday: "long" });
}

// ============================
//   INICIALIZACIÓN POR PÁGINA
// ============================
document.addEventListener("DOMContentLoaded", () => {
  const page = document.body.dataset.page;
  const data = loadDemoData();

  switch (page) {
    case "login":
      initLoginPage(data);
      break;
    case "admin":
      initAdminPage(data);
      break;
    case "planificacion":
      initPlanificacionPage(data);
      break;
    case "rutas-semana":
      initRutasSemanaPage(data);
      break;
  }
});

// ============================
//   LOGIN
// ============================
function initLoginPage(data) {
  const form = document.getElementById("loginForm");
  const errorBox = document.getElementById("loginError");

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    errorBox.style.display = "none";

    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();

    const user = data.users.find((u) => u.email === email && u.password === password);

    if (!user) {
      errorBox.style.display = "block";
      return;
    }

    setCurrentUser({ id: user.id, nombre: user.nombre, email: user.email, rol: user.rol });
    window.location.href = "admin.html";
  });
}

// ============================
//   ADMIN PANEL
// ============================
function initAdminPage(data) {
  const user = getCurrentUser();
  if (!user) {
    window.location.href = "index.html";
    return;
  }

  const spanUser = document.getElementById("currentUserName");
  if (spanUser) spanUser.textContent = user.nombre + " (" + user.rol + ")";

  const btnLogout = document.getElementById("btnLogout");
  btnLogout.addEventListener("click", () => {
    setCurrentUser(null);
    window.location.href = "index.html";
  });

  // Botón Nueva planificación
  const btnNuevaPlan = document.getElementById("btnNuevaPlan");
  btnNuevaPlan.addEventListener("click", () => {
    localStorage.removeItem(STORAGE_EDIT_ROUTE);
    window.location.href = "planificacion.html";
  });

  // KPI: camiones operativos
  const camOperativos = data.camiones.filter((c) => c.estado === "operativo").length;
  document.getElementById("cardCamiones").textContent = camOperativos;

  // Rutas de hoy
  const hoy = new Date().toISOString().slice(0, 10);
  const rutasHoy = data.rutas.filter((r) => r.fecha === hoy);
  document.getElementById("cardRutas").textContent = rutasHoy.length;

  // Incidencias abiertas (demo: cantidad del arreglo)
  document.getElementById("cardIncidencias").textContent = data.incidencias.length;

  // Tabla rutas del día
  const tbody = document.getElementById("tablaRutas");
  tbody.innerHTML = "";

  rutasHoy.forEach((ruta) => {
    const camion = data.camiones.find((c) => c.id === ruta.camionId);
    const chofer = data.users.find((u) => u.id === ruta.choferId);
    const colNombres = ruta.coloniasIds
      .map((idCol) => {
        const col = data.colonias.find((c) => c.id === idCol);
        return col ? col.nombre : "";
      })
      .filter(Boolean)
      .join(", ");

    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${formatFecha(ruta.fecha)}</td>
      <td>${camion ? camion.numero : "-"}</td>
      <td>${chofer ? chofer.nombre : "-"}</td>
      <td>${colNombres || "-"}</td>
      <td><span class="badge badge-pill">${ruta.estado}</span></td>
      <td>
        <button class="btn btn-outline-secondary btn-sm" data-edit-ruta="${ruta.id}">
          Editar
        </button>
      </td>
    `;
    tbody.appendChild(tr);
  });

  // Eventos de Editar
  tbody.addEventListener("click", (e) => {
    const btn = e.target.closest("button[data-edit-ruta]");
    if (!btn) return;
    const rutaId = Number(btn.dataset.editRuta);
    localStorage.setItem(STORAGE_EDIT_ROUTE, String(rutaId));
    window.location.href = "planificacion.html";
  });

  // Incidencias demo
  const tbodyInc = document.getElementById("tablaIncidencias");
  tbodyInc.innerHTML = "";
  data.incidencias.forEach((i) => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${i.hora}</td>
      <td>${i.camion}</td>
      <td>${i.chofer}</td>
      <td>${i.tipo}</td>
      <td>${i.colonia}</td>
      <td>${i.descripcion}</td>
    `;
    tbodyInc.appendChild(tr);
  });
}

// ============================
//   PLANIFICACIÓN NUEVA / EDITAR
// ============================
function initPlanificacionPage(data) {
  const user = getCurrentUser();
  if (!user) {
    window.location.href = "index.html";
    return;
  }

  const form = document.getElementById("planForm");
  const fechaInput = document.getElementById("fecha");
  const selCamion = document.getElementById("camion");
  const selChofer = document.getElementById("chofer");
  const selColonias = document.getElementById("colonias");
  const msg = document.getElementById("planMsg");
  const btnCancelar = document.getElementById("btnCancelarPlan");
  const title = document.getElementById("planTitle");

  // Fecha por defecto: hoy
  const hoy = new Date().toISOString().slice(0, 10);
  fechaInput.value = hoy;

  // Cargar camiones
  data.camiones.forEach((c) => {
    if (c.estado !== "operativo") return;
    const opt = document.createElement("option");
    opt.value = c.id;
    opt.textContent = `${c.numero} (${c.estado})`;
    selCamion.appendChild(opt);
  });

  // Cargar choferes
  selChofer.innerHTML = `<option value="">Seleccione un chofer</option>`;
  data.users
    .filter((u) => u.rol === "chofer")
    .forEach((ch) => {
      const opt = document.createElement("option");
      opt.value = ch.id;
      opt.textContent = ch.nombre;
      selChofer.appendChild(opt);
    });

  // Cargar colonias
  selColonias.innerHTML = "";
  data.colonias.forEach((col) => {
    const opt = document.createElement("option");
    opt.value = col.id;
    opt.textContent = col.nombre;
    selColonias.appendChild(opt);
  });

  // ¿Modo edición?
  const editIdRaw = localStorage.getItem(STORAGE_EDIT_ROUTE);
  let editRoute = null;

  if (editIdRaw) {
    const id = Number(editIdRaw);
    editRoute = data.rutas.find((r) => r.id === id);
    if (editRoute) {
      title.textContent = "Editar ruta del día";
      fechaInput.value = editRoute.fecha;
      selCamion.value = editRoute.camionId;
      selChofer.value = editRoute.choferId;

      // Seleccionar colonias
      Array.from(selColonias.options).forEach((opt) => {
        if (editRoute.coloniasIds.includes(Number(opt.value))) {
          opt.selected = true;
        }
      });
    } else {
      localStorage.removeItem(STORAGE_EDIT_ROUTE);
    }
  }

  // Guardar / actualizar
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    msg.style.display = "none";

    const fecha = fechaInput.value;
    const camionId = Number(selCamion.value);
    const choferId = Number(selChofer.value);
    const coloniasIds = Array.from(selColonias.selectedOptions).map((o) => Number(o.value));

    if (!fecha || !camionId || !choferId || coloniasIds.length === 0) {
      alert("Completa todos los campos y selecciona al menos una colonia.");
      return;
    }

    if (editRoute) {
      // Actualizar
      editRoute.fecha = fecha;
      editRoute.camionId = camionId;
      editRoute.choferId = choferId;
      editRoute.coloniasIds = coloniasIds;
    } else {
      // Crear nuevo
      const newId = (data.rutas[data.rutas.length - 1]?.id || 0) + 1;
      data.rutas.push({
        id: newId,
        fecha,
        camionId,
        choferId,
        coloniasIds,
        estado: "Planeada",
      });
    }

    saveDemoData(data);
    msg.style.display = "block";

    setTimeout(() => {
      window.location.href = "admin.html";
    }, 800);
  });

  btnCancelar.addEventListener("click", () => {
    window.location.href = "admin.html";
  });
}

// ============================
//   RUTAS DE LA SEMANA
// ============================
function initRutasSemanaPage(data) {
  const user = getCurrentUser();
  if (!user) {
    window.location.href = "index.html";
    return;
  }

  const tbody = document.getElementById("tablaSemana");
  tbody.innerHTML = "";

  // Tomamos todas las rutas y las ordenamos por fecha
  const rutas = [...data.rutas].sort((a, b) => (a.fecha > b.fecha ? 1 : -1));

  rutas.forEach((ruta) => {
    const camion = data.camiones.find((c) => c.id === ruta.camionId);
    const chofer = data.users.find((u) => u.id === ruta.choferId);
    const colNombres = ruta.coloniasIds
      .map((idCol) => {
        const col = data.colonias.find((c) => c.id === idCol);
        return col ? col.nombre : "";
      })
      .filter(Boolean)
      .join(", ");

    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${diaSemana(ruta.fecha)}</td>
      <td>${formatFecha(ruta.fecha)}</td>
      <td>${camion ? camion.numero : "-"}</td>
      <td>${chofer ? chofer.nombre : "-"}</td>
      <td>${colNombres || "-"}</td>
      <td><span class="badge badge-pill">${ruta.estado}</span></td>
    `;
    tbody.appendChild(tr);
  });
}
