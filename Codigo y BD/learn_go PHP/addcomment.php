<?php

ob_clean();

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: *");

include 'conexion.php';

// Recibe los datos del comentario
$postId = $_POST['postId'];
$id_usuario = $_POST['id_usuario'];
$descripcion = $_POST['descripcion'];

// Verifica si los datos recibidos son válidos
if (isset($postId, $id_usuario, $descripcion)) {
    // Escapa los datos para prevenir inyección de SQL
    $postId = mysqli_real_escape_string($connect, $postId);
    $id_usuario = mysqli_real_escape_string($connect, $id_usuario);
    $descripcion = mysqli_real_escape_string($connect, $descripcion);

    // Inserta el comentario en la base de datos
    $sql = "INSERT INTO comentarios (postId, id_usuario, descripcion) VALUES ('$postId', '$id_usuario', '$descripcion')";

    if ($connect->query($sql) === TRUE) {
        // Enviar una respuesta de éxito si la inserción fue exitosa
        echo json_encode(['success' => true, 'message' => 'Comentario guardado con éxito']);
    } else {
        // Enviar una respuesta de error si hubo un problema con la inserción
        echo json_encode(['success' => false, 'message' => 'Error al guardar el comentario: ' . $connect->error]);
    }
} else {
    // Enviar una respuesta de error si los datos no son válidos
    echo json_encode(['success' => false, 'message' => 'Datos de comentario no válidos']);
}

?>
