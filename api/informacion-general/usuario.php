<?php

if(
    !isset($_GET['peticion'])
) {
    exit('Datos Faltantes');
}

$peticion = $_GET['peticion'];

switch ($peticion) {
    case 'sesion-creada':
        session_start();
        echo isset($_SESSION['id_usuario']) ? 1 : 0;
        break;    
    
    case 'cerrar-sesion':
        session_start();
        session_unset();
        echo 1;
        break;
}
?>