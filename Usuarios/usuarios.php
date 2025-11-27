<?php
require_once __DIR__ . "/../backend/config.php";

/* GUARDAR USUARIO */
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombre   = $_POST["nombre"];
    $telefono = $_POST["telefono"];
    $rol      = $_POST["rol"];
    $pass     = $_POST["password"];

    $stmt = $conn->prepare("INSERT INTO usuarios (nombre, telefono, rol, password) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $nombre, $telefono, $rol, $pass);
    $stmt->execute();
    $stmt->close();

    header("Location: usuarios.php"); // refresca
    exit;
}

/* LISTAR USUARIOS */
$usuarios = $conn->query("SELECT * FROM usuarios ORDER BY id DESC");
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Usuarios</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">

<h2>Usuarios</h2>

<form method="POST" class="row g-3">

<div class="col-md-3">
<input name="nombre" class="form-control" placeholder="Nombre" required>
</div>

<div class="col-md-3">
<input name="telefono" class="form-control" placeholder="Teléfono">
</div>

<div class="col-md-3">
<select name="rol" class="form-select">
<option value="admin">admin</option>
<option value="supervisor">supervisor</option>
<option value="chofer">chofer</option>
<option value="ayudante">ayudante</option>
</select>
</div>

<div class="col-md-3">
<input type="password" name="password" class="form-control" placeholder="Contraseña" required>
</div>

<div class="col-12">
<button class="btn btn-success w-100">Guardar</button>
</div>

</form>

<table class="table table-striped mt-4">
<thead>
<tr>
<th>ID</th>
<th>Nombre</th>
<th>Teléfono</th>
<th>Rol</th>
</tr>
</thead>
<tbody>

<?php while ($u = $usuarios->fetch_assoc()): ?>
<tr>
<td><?= $u["id"] ?></td>
<td><?= htmlspecialchars($u["nombre"]) ?></td>
<td><?= htmlspecialchars($u["telefono"]) ?></td>
<td><?= $u["rol"] ?></td>
</tr>
<?php endwhile; ?>

</tbody>
</table>

</div>
</body>
</html>
