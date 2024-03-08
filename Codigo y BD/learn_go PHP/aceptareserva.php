<?php

include 'conexion.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $estado_reserva = $_POST['estado_reserva'];

    // Realizar la actualización en la base de datos
    $sql = "UPDATE reservas SET estado_reserva = '$estado_reserva' WHERE id = $id";

    if (mysqli_query($connect, $sql)) {
        // Éxito en la actualización
        echo json_encode(["message" => "Estado de reserva actualizado correctamente"]);
    } else {
        // Error en la actualización
        echo json_encode(["error" => "Error al actualizar el estado de reserva"]);
    }
} else {
    // Método no permitido
    echo json_encode(["error" => "Método no permitido"]);
}

// Cerrar la conexión a la base de datos
mysqli_close($connect);

?>

