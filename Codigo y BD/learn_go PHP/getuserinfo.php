<?php
header('Content-Type: application/json');
include 'conexion.php';

// Obtener el id del usuario de la solicitud GET
$userId = $_GET['id'];

// Consultar el nombre del usuario basado en el id_usuario
$sql = "SELECT nombre FROM usuarios WHERE id = $userId";
$result = $connect->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $userName = $row["nombre"];

    // Devolver el nombre del usuario como respuesta JSON
    echo json_encode(['nombre' => $userName]);
} else {
    // Si el usuario no se encuentra, devolver un mensaje de error
    echo json_encode(['error' => 'Usuario no encontrado']);
}

?>