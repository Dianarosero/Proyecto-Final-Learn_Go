<?php

    include 'conexion.php';

    $email = $_POST['email'];
	$password = $_POST['password'];

    $consultar=$connect->query("SELECT * FROM usuarios WHERE email='".$email."' and password='".$password."'");

    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

    ?>