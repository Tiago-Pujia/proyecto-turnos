<?php
if(!isset($_GET['email'])){
    echo 'Datos faltantes';
    exit();
}

$email = $_GET['email'];

include_once '../crud.php';
include_once '../funciones.php';
include_once '../enviar-correo.php';

if(empty($crud->query("SELECT 1 FROM vw_usuarios_activos WHERE email = '$email'"))){
    exit('Usuario no encontrado');
}

$data = $crud->query("SELECT id_usuario,password FROM vw_usuarios_activos WHERE email = '$email'")[0];
$id_usuario = $data[0];
$token = crear_token($data[1]);


$enviar_correo = new Enviar_Correos();
$enviar_correo->olvide_contrasena($email,$id_usuario,$token);


echo 1;

?>