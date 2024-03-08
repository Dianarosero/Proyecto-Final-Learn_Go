<?php

include 'conexion.php';

$id_usuario = $_POST['id_usuario'];
$descripcion = $_POST['descripcion'];

// Preparar la consulta
$query = "INSERT INTO publicaciones (id_usuario, descripcion) VALUES ('$id_usuario', '$descripcion')";

// Ejecutar la consulta y manejar errores
if ($connect->query($query) === TRUE) {
    echo "Registro insertado correctamente";
} else {
    echo "Error al insertar el registro: " . $connect->error;
}

// Cerrar la conexión
$connect->close();

?>
