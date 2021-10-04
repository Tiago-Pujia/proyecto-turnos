<?php
if(!isset($_GET['id_usuario']) || !isset($_GET['token']) || !isset($_GET['nuevo_password'])){
    echo 'Datos Faltantes';
    exit();
}

$ruta = $_SERVER['DOCUMENT_ROOT'];
include_once "$ruta/api/crud.php";

$id_usuario = $_GET['id_usuario'];
$token = $_GET['token'];
$nuevo_password = $_GET['nuevo_password'];

if(strlen($nuevo_password) < 5){
    exit('Debe haber 5 caracteres como mínimo');
}

if(strlen($nuevo_password) >= 20){
    exit('Limite de caracteres permitidos 20');
}

include_once '../funciones.php';
$token_bd = crear_token($crud->query("SELECT password FROM vw_usuarios_activos WHERE id_usuario = $id_usuario")[0][0]);

if($token != $token_bd){
    exit('Token Incorrecto');
}

$nuevo_password = password_hash($nuevo_password,PASSWORD_ARGON2ID);

$crud->exec("UPDATE tbl_usuarios SET password = '$nuevo_password' WHERE id_usuario = $id_usuario");

echo 1;

?>