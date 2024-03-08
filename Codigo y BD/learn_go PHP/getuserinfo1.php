<?php
header('Content-Type: application/json');
include 'conexion.php';

// Obtener el correo electrónico del parámetro de la solicitud GET
$email = $_GET["email"];

// Consulta SQL para obtener la información del usuario basado en el correo electrónico
$sql = "SELECT id, nombre, apellido, edad, id_rol, email FROM usuarios WHERE email = '$email'";

// Ejecutar la consulta
$result = $connect->query($sql);

if ($result->num_rows > 0) {
    // Convertir el resultado a un array asociativo
    $row = $result->fetch_assoc();

    // Devolver los datos como JSON
    echo json_encode($row);
} else {
    // Si no se encuentra el usuario, devolver un mensaje de error
    echo json_encode(["error" => "Usuario no encontrado"]);
}


?>