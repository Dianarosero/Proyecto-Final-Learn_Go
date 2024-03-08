<?php
include 'conexion.php';

// Consulta para obtener los nombres de las materias
$query = "SELECT id, nombre FROM materias";
$result = mysqli_query($connect, $query);

if ($result) {
    $materias = array();

    // Recorrer los resultados y almacenar los nombres en un array
    while ($row = mysqli_fetch_assoc($result)) {
        $materias[] = $row;
    }

    // Convertir el array a formato JSON y enviarlo como respuesta
    echo json_encode($materias);
} else {
    // Manejar el error si la consulta no fue exitosa
    echo "Error en la consulta: " . mysqli_error($connect);
}

?>