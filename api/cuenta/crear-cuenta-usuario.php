<?php

if(!(
    isset($_GET['nombre'])              || 
    isset($_GET['apellido'])            || 
    isset($_GET['sexo'])                || 
    isset($_GET['fecha_nacimiento'])    || 
    isset($_GET['email'])               || 
    isset($_GET['password'])
)) {
    exit('Campos Faltantes');
}

require '../crud.php';
require '../composer/vendor/autoload.php';

function validar_campos($arr_campos){
    $errores_campos = [];

    foreach ($arr_campos as $value) {
        $campo = $value[0];
        $condicional = $value[1];
        $mensaje = $value[2];

        if($condicional){
            if(!array_key_exists($campo,$errores_campos)){
                $errores_campos[$campo] = [];
            };
        
            array_push($errores_campos[$campo],$mensaje);
        }
    }

    return $errores_campos;
}

$nombre             = $_GET['nombre'];
$apellido           = $_GET['apellido'];
$sexo               = number_format($_GET['sexo']);
$fecha_nacimiento   = $_GET['fecha_nacimiento'];
$email              = $_GET['email'];
$password           = $_GET['password'];

$validar_email = $crud->query("SELECT validar_email('$email') AS a;")[0][0];

$condicionales_campos = [
    ['nombre',strlen($nombre) <= 2,'Nombre Incompleto'],
    ['nombre',strlen($nombre) >= 200,'Limite de caracteres permitidos 200'],
    ['apellido',strlen($apellido) <= 2,'Apellido incompleto'],
    ['apellido',strlen($apellido) >= 100,'Limite de caracteres permitidos 100'],
    ['sexo',$sexo != (0 && 1),'Sexo Invalido'],
    ['fecha_nacimiento',empty($fecha_nacimiento),'Fecha invalida'],
    ['fecha_nacimiento',strtotime(date('20y-m-d')) <= strtotime($fecha_nacimiento),'Fecha invalida'],
    ['password',strlen($password) < 5,'Debe haber 5 caracteres como mínimo'],
    ['password',strlen($password) >= 20,'Limite de caracteres permitidos 20'],
    ['email',!filter_var($email,FILTER_VALIDATE_EMAIL),'Correo invalido'],
    ['email',$validar_email != 1,$validar_email]
];

$errores_datos = validar_campos($condicionales_campos);

if(count($errores_datos) >= 1){
    echo json_encode($errores_datos,JSON_UNESCAPED_UNICODE);
    exit();
}

include_once '../funciones.php';

$password = password_hash($password,PASSWORD_ARGON2ID);
$token = crear_token($password);

$crud->conectar();
    $crud->query_sin_connection("INSERT INTO tbl_usuarios (nombre,apellido,fecha_nacimiento,sexo,email,password) VALUES ('$nombre','$apellido','$fecha_nacimiento',$sexo,'$email','$password')");
    $id_usuario = $crud->query_sin_connection("SELECT id_usuario FROM tbl_usuarios WHERE email = '$email'")[0][0];
$crud->desconectar();

require '../enviar-correo.php';
$activar_cuenta = new Enviar_Correos();
$activar_cuenta->confirmar_correo($email,$id_usuario,$token);

echo 1;

?>