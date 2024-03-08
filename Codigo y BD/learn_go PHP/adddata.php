<?php

include 'conexion.php';

$nombre = $_POST['nombre'];
$apellido = $_POST['apellido'];
$edad = $_POST['edad'];
$rol = $_POST['id_rol'];
$email = $_POST['email'];
$password = $_POST['password'];
$id_materia = $_POST['id_materia'];

// Preparar la consulta
$query = "INSERT INTO usuarios (nombre, apellido, edad, id_rol, email, password, id_materia) VALUES ('$nombre', '$apellido', '$edad', '$rol', '$email', '$password', '$id_materia')";

// Ejecutar la consulta y manejar errores
if ($connect->query($query) === TRUE) {
    echo "Registro insertado correctamente";
} else {
    echo "Error al insertar el registro: " . $connect->error;
}

// Cerrar la conexión
$connect->close();

?>
