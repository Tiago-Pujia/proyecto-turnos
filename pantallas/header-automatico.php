<?php

$id_rol = 0;

if(session_status() != 2){
    session_start();
}

if(isset($_SESSION['id_usuario'])){
    include_once '../api/crud.php';

    $id_usuario = $_SESSION['id_usuario'];
    $id_rol = $crud->query("SELECT id_rol FROM vw_usuarios_activos WHERE id_usuario = $id_usuario")[0][0];            
} else {
    session_unset();
}


switch ($id_rol) {
    case 0:
        include 'header-rol-0.php';
        break;
    case 1:
        include 'header-rol-1.php';
        break;
    case 2:
        include 'header-rol-2.php';
        break;
    case 3:
        include 'header-rol-3.php';
        break;
}

?>