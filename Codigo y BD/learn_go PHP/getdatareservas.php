<?php
header('Content-Type: application/json');
include 'conexion.php';

// Obtén el id_estudiante de la URL (cambia de id_usuario a id_estudiante)
$id_estudiante = $_GET["id_estudiante"];

// Utiliza una consulta preparada para evitar la inyección SQL
$sql = "SELECT id, id_estudiante, id_materia, id_tutor, fecha, hora, tipo_reunion, precio, estado_reserva FROM reservas WHERE id_estudiante = ?";
$stmt = $connect->prepare($sql);

// Vincula el parámetro id_estudiante a la consulta
$stmt->bind_param("i", $id_estudiante);

// Ejecutar la consulta
$stmt->execute();

// Obtener los resultados
$result = $stmt->get_result();

if ($result === false) {
    // Si hay un error en la consulta, devolver un mensaje de error
    echo json_encode(["error" => $connect->error]);
} else {
    // Obtener todas las filas
    $rows = $result->fetch_all(MYSQLI_ASSOC);

    if (empty($rows)) {
        // Si no hay reservas, devolver un mensaje de error
        echo json_encode(["error" => "No se encontraron reservas"]);
    } else {
        // Devolver los datos como JSON
        echo json_encode($rows);
    }
}

// Cerrar la conexión y la declaración preparada
$stmt->close();
$connect->close();
?>
