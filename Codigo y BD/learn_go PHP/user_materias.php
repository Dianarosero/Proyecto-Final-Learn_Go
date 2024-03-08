<?php

	include 'conexion.php';
	
	$nombre = $_POST['nombre'];
	$apellido = $_POST['apellido'];
	$edad = $_POST['edad'];
	$rol = $_POST['id_rol'];
	$email = $_POST['email'];
	$password = $_POST['password'];
	
	$connect->query("INSERT INTO usuarios (nombre, apellido, edad, id_rol, email, password) VALUES ('".$nombre."','".$apellido."','".$edad."','".$rol."','".$email."','".$password."')")

?>