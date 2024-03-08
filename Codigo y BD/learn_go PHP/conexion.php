<?php

$connect =  mysqli_connect("localhost","root","","learn_go");

if($connect){
	 
}else{
	echo "Fallo, revise ip o firewall";
	exit();
}