<?php
    if( !isset($_GET['email']) || !isset($_GET['password']) ) {
        echo 'Datos Faltantes';
        exit();
    }

    include_once '../crud.php';

    $crud = new CRUD();

    function obetener_datos_inicio_sesion($email){
        global $crud;
        $respuesta = $crud->query("SELECT id_usuario,password FROM vw_tbl_usuarios_activos WHERE email = '$email'");
        return $respuesta;
    }

    $email = $_GET['email'];
    $password = $_GET['password'];
    $data = obetener_datos_inicio_sesion($email);

    if(empty($data)){
        echo 'Usuario no encontrado';
        exit();
    }

    $id_usuario = $data[0][0];
    $password_bd = $data[0][1];  

    if(password_verify($password,$password_bd)){
        session_start();
        $_SESSION['id_usuario'] = $id_usuario;
        echo 1;
    } else {
        echo 'Correo o contraseña incorrectos';
    }
?>