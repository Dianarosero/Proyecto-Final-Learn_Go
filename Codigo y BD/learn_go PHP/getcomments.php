<?php

ob_clean();

// Agrega estas líneas al principio de tu script PHP
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");

header('Content-Type: application/json');
include 'conexion.php';
$postId = $_GET['postId'];

// Verificar si $postId está presente y no está vacío
if (isset($postId) && !empty($postId)) {

    // Consultar comentarios basados en la id_publicacion
    $sql = "SELECT * FROM comentarios WHERE postId = $postId";
    $result = $connect->query($sql);

    $comments = array();

    // Verificar si la consulta fue exitosa
    if ($result === false) {
        die("Query failed: " . $connect->error);
    }

    // Recorrer los resultados de la consulta
    while ($row = $result->fetch_assoc()) {
        $comments[] = $row;
    }

    // Devolver comentarios como respuesta JSON
    echo json_encode($comments);

    // Terminar la ejecución del script
    exit();
} else {
    // Si $postId no está presente o está vacío
    die("Invalid or missing postId");
}

?>
