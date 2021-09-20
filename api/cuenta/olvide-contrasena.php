<?php
if(!isset($_GET['id_usuario']) || !isset($_GET['token']) || !isset($_GET['nuevo_password'])){
    echo 'Datos Faltantes';
    exit();
}

include_once '../crud.php';

$crud = new CRUD();

$id_usuario = $_GET['id_usuario'];
$token = $_GET['token'];
$nuevo_password = $_GET['nuevo_password'];

function obtener_token($id_usuario){
    global $crud;
    
    $respuesta = $crud->query("SELECT password FROM vw_tbl_usuarios_activos WHERE id_usuario = $id_usuario");
    $respuesta = urldecode(substr($respuesta[0][0],29));
    return $respuesta;
}

function actualizar_password($password,$id_usuario){
    global $crud;

    $crud->exec("UPDATE tbl_usuarios SET password = '$password' WHERE id_usuario = $id_usuario");
    return 1;
}

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

$condicionales_campos = [
    ['password',strlen($nuevo_password) < 5,'Debe haber 5 caracteres como mínimo'],
    ['password',strlen($nuevo_password) >= 20,'Limite de caracteres permitidos 20'],
];

$errores_datos = validar_campos($condicionales_campos);

if(count($errores_datos) >= 1){
    echo json_encode($errores_datos,JSON_UNESCAPED_UNICODE);
    exit();
}

$token_bd = obtener_token($id_usuario);

if($token == $token_bd){
    $nuevo_password = password_hash($nuevo_password,PASSWORD_ARGON2ID);
    actualizar_password($nuevo_password,$id_usuario);
    echo 1;
} else {
    echo 'Token Incorrecto';
}

?>