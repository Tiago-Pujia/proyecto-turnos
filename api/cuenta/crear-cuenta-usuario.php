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

$crud = new CRUD();

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

function insertar_usuario($nombre,$apellido,$fecha_nacimiento,$sexo,$email,$password){
    global $crud;
    $crud->query("SELECT insertar_usuario('$nombre','$apellido','$fecha_nacimiento',$sexo,'$email','$password')");
    return 1;
}

function id_usuario($email){
    global $crud;
    $respuesta = $crud->query("SELECT id_usuario FROM tbl_usuarios WHERE email = '$email'");
    return $respuesta[0][0];
}

function validar_email($email){
    global $crud;
    $respuesta = $crud->query("SELECT validar_email('$email') AS a;");
    return $respuesta[0][0];
}

$nombre             = $_GET['nombre'];
$apellido           = $_GET['apellido'];
$sexo               = $_GET['sexo'];
$fecha_nacimiento   = $_GET['fecha_nacimiento'];
$email              = $_GET['email'];
$password           = $_GET['password'];

$validar_email = validar_email($email);

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

$password = password_hash($password,PASSWORD_ARGON2ID);

insertar_usuario($nombre,$apellido,$fecha_nacimiento,$sexo,$email,$password);


require '../enviar-correo.php';

$email_asunto = 'Gracias por registrarte, por favor verifique su cuenta';
$email_cuerpo = '
<h1 style="color:red;">Verificacion de Correo electronico</h1>
<p>Haga click en el boton</p>
<p><a href="' . $_SERVER['SERVER_NAME'] . '/cuenta/confirmar-correo/?id_usuario=' . id_usuario($email) . '&token=' . urldecode(substr($password,29)) . '">Verificar</a></p>'
;

sendMail($email,$email_asunto,$email_cuerpo);

echo 1;

?>