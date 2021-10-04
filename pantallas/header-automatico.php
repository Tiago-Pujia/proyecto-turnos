<?php

$id_rol = 0;
$ruta = $_SERVER["DOCUMENT_ROOT"];

if(session_status() != 2){
    session_start();
}

if(isset($_SESSION['id_usuario'])){
    include_once "$ruta/api/crud.php";

    $id_usuario = $_SESSION['id_usuario'];
    $id_rol = $crud->query("SELECT id_rol FROM vw_usuarios_activos WHERE id_usuario = $id_usuario")[0][0];            
} else {
    session_unset();
}


switch ($id_rol) {
    case 0:
        include "$ruta/pantallas/header-rol-0.php";
        break;
    case 1:
        include "$ruta/pantallas/header-rol-1.php";
        break;
    case 2:
        include "$ruta/pantallas/header-rol-2.php";
        break;
    case 3:
        include "$ruta/pantallas/header-rol-3.php";
        break;
    case 4:
        include "$ruta/pantallas/header-rol-4.php";
        break;
}

?>