<?php
include 'conexion.php';

// Verificar si se recibieron datos por POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtener datos del POST
    $id_estudiante = $_POST['id_estudiante'];
    $id_materia = $_POST['id_materia'];
    $id_tutor = $_POST['id_tutor'];
    $fecha = $_POST['fecha'];
    $hora = $_POST['hora'];
    $tipo_reunion = $_POST['tipo_reunion'];
    $precio = $_POST['precio'];
    $estado_reserva = "En Espera";

    // Utilizar consultas preparadas para evitar la inyección de SQL
    $stmt = $connect->prepare("INSERT INTO reservas (id_estudiante, id_materia, id_tutor, fecha, hora, tipo_reunion, precio, estado_reserva) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("iiisssds", $id_estudiante, $id_materia, $id_tutor, $fecha, $hora, $tipo_reunion, $precio, $estado_reserva);

    // Ejecutar la inserción
    if ($stmt->execute()) {
        echo json_encode(["success" => "Reserva creada exitosamente"]);
    } else {
        echo json_encode(["error" => "Error al crear reserva"]);
    }

    // Cerrar la declaración preparada
    $stmt->close();
} else {
    echo json_encode(["error" => "Solicitud no válida"]);
}

// Cerrar la conexión
$connect->close();
?>
