document.addEventListener("DOMContentLoaded", async () => {

  // ================================
  //  BOTÓN DE CERRAR SESIÓN
  // ================================
  const btnLogout = document.getElementById('btnLogout');
  btnLogout.addEventListener('click', () => {
    localStorage.removeItem('token');
    window.location.href = 'index.html';
  });

  // ================================
  //  BOTÓN: NUEVA PLANIFICACIÓN
  // ================================
  const btnPlan = document.getElementById("btnPlanificacion");
  if (btnPlan) {
    btnPlan.addEventListener("click", () => {
      window.location.href = "planificacion.html";
    });
  }

  // ================================
  //   CARGA DE DATOS DEL DASHBOARD
  // ================================
  try {
    // Datos de dashboard
    const dash = await apiGetDashboard();
    document.getElementById('cardCamiones').textContent   = dash.camiones_operativos;
    document.getElementById('cardRutas').textContent      = dash.rutas_hoy;
    document.getElementById('cardIncidencias').textContent= dash.incidencias_abiertas;

    // Rutas del día
    const rutas = await apiGetRutasHoy();
    const tbodyRutas = document.getElementById('tablaRutas');
    tbodyRutas.innerHTML = "";
    rutas.forEach(r => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
    <td>${r.fecha}</td>
    <td>${r.camion}</td>
    <td>${r.chofer}</td>
    <td>${r.total_colonias}</td>
    <td>${r.estado}</td>
    <td>
        <button class="btn btn-warning btn-sm" onclick="editarRuta(${r.id})">
            Modificar
        </button>
    </td>
`;

      tbodyRutas.appendChild(tr);
    });

    // Incidencias
    const incidencias = await apiGetIncidencias();
    const tbodyInc = document.getElementById('tablaIncidencias');
    tbodyInc.innerHTML = "";
    incidencias.forEach(i => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
    <td>${r.fecha}</td>
    <td>${r.camion}</td>
    <td>${r.chofer}</td>
    <td>${r.total_colonias}</td>
    <td>${r.estado}</td>
    <td>
        <button class="btn btn-warning btn-sm" onclick="editarRuta(${r.id})">
            Modificar
        </button>
    </td>
`;
      tbodyInc.appendChild(tr);
    });

  } catch (err) {
/*    console.error(err);
    alert("Error al cargar el panel. Verifica que el backend esté encendido.");
  */}
  function editarRuta(id) {
    window.location.href = `editar_ruta.html?id=${id}`;
}

});
