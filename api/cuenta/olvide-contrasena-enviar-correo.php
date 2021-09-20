<?php
if(!isset($_GET['email'])){
    echo 'Datos faltantes';
    exit();
}

include_once '../crud.php';
include_once '../enviar-correo.php';

$crud = new CRUD();
$email = $_GET['email'];

function validar_usuario_existente($email){
    global $crud;
    $respuesta = $crud->query("SELECT 1 FROM vw_tbl_usuarios_activos WHERE email = '$email'");
    return $respuesta;
}

function obetener_datos_usuario($email){
    global $crud;
    $respuesta = $crud->query("SELECT id_usuario,password FROM vw_tbl_usuarios_activos WHERE email = '$email'");
    return $respuesta;
}

if(empty(validar_usuario_existente($email))){
    echo 'Usuario no encontrado';
    exit();
}

$data = obetener_datos_usuario($email);
$id_usuario = $data[0][0];
$token = $data[0][1]; 

$asunto = 'Cambiar contraseña';
$cuerpo = '<p>
Enviaste una peticion de cambiar contraseña por olvido, entra al <a href="'  
. $_SERVER['SERVER_NAME'] . '/cuenta/olvide-contrasena/?id_usuario=' 
. $id_usuario . '&token='
. urldecode(substr($token,29)) 
. '">enlace</a> para cambiarla
</p>';

sendMail($email,$asunto,$cuerpo);

echo 1;

?>