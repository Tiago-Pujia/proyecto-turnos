<?php
    if( !isset($_GET['email']) || !isset($_GET['password']) ) {
        echo 'Datos Faltantes';
        exit();
    }

    include_once '../crud.php';

    $email = $_GET['email'];
    $password = $_GET['password'];
    
    $data = $crud->query("SELECT id_usuario,password,fecha_confirmacion,fecha_baja FROM tbl_usuarios WHERE email = '$email'");

    if(empty($data)) {
        exit('Usuario no encontrado');
    } 

    $data = $data[0];
    $id_usuario = $data[0];
    $password_bd = $data[1];
    $fecha_confirmacion = $data[2];
    $fecha_baja = $data[3];

    if(empty($fecha_confirmacion)) {
        exit('Confirme su correo electronico para iniciar sesion');
    }

    if(!empty($fecha_baja)) {
        include_once '../enviar-correo.php';
        include_once '../funciones.php';
        
        $token = crear_token($password_bd);
        
        $activar_cuenta = new Enviar_Correos();
        $activar_cuenta->activar_cuenta($email,$id_usuario,$token);

        exit('Diste de baja tu cuenta, revisa tu correo para volverla a activar');
    }

    if(!password_verify($password,$password_bd)) {
        exit('Correo o contraseña incorrectos');
    }

    session_start();
    $_SESSION['id_usuario'] = $id_usuario;

    $crud->exec("UPDATE tbl_usuarios SET fecha_ultimo_ingreso = now() WHERE id_usuario = $id_usuario");

    echo 1;
?>