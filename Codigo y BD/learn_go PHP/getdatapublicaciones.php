<?php
include 'conexion.php';

$queryResult=$connect->query("SELECT * FROM publicaciones ORDER by 1 DESC");

$result=array();

while($fetchData=$queryResult->fetch_assoc()){
	$result[]=$fetchData;
}

echo json_encode($result);

?>
