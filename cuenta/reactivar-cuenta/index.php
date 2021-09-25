<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reactivar Cuenta</title>

    <script src="/independencias/jquery.js"></script>
    <script src="/independencias/jquery-jquery-cookie.js"></script>
    <link rel="stylesheet" href="/independencias/normalize.css" />
</head>
<body>
    <h1>Confirmar Correo</h1>
    <p>
    <?php

    if( !isset($_GET['id_usuario']) || !isset($_GET['token']) ) {
        exit('Datos Faltantes en la URL');
    }

    include_once '../../api/crud.php';
    include_once '../../api/funciones.php';

    $id_usuario = $_GET['id_usuario'];
    $password = $_GET['token'];
    $token_bd = crear_token($crud->query("SELECT password FROM tbl_usuarios WHERE id_usuario = $id_usuario")[0][0]);

    if($password != $token_bd){
        exit('Token Erroneo');
    }

    $crud->exec("UPDATE tbl_usuarios SET fecha_baja = NULL WHERE id_usuario = $id_usuario");

    echo 'Gracias por volver a estar con nosotros';
    ?>
    </p>
</body>
</html>