<?php
header('Content-Type: application/json');
include 'conexion.php';

// Obtén el id_usuario de la URL
$id_usuario = $_GET["id_usuario"];

// Utiliza una consulta preparada para evitar la inyección SQL
$sql = "SELECT id, id_usuario, fecha, descripcion FROM publicaciones WHERE id_usuario = ?";
$stmt = $connect->prepare($sql);

// Vincula el parámetro id_usuario a la consulta
$stmt->bind_param("i", $id_usuario);

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
        // Si no hay publicaciones, devolver un mensaje de error
        echo json_encode(["error" => "No se encontraron publicaciones"]);
    } else {
        // Devolver los datos como JSON
        echo json_encode($rows);
    }
}

// Cerrar la conexión y la declaración preparada
$stmt->close();
$connect->close();
?>
