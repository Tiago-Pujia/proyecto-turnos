<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmar Correo</title>

    <script src="/independencias/jquery.js"></script>
    <script src="/independencias/jquery-jquery-cookie.js"></script>
    <link rel="stylesheet" href="/independencias/normalize.css" />
</head>
<body>
    <h1>Confirmar Correo</h1>
    <p>
    <?php

    if( !isset($_GET['id_usuario']) || !isset($_GET['token']) ) {
        echo 'Datos Faltantes en la URL';
        exit();
    }

    include_once '../../api/crud.php';
    include_once '../../api/composer/vendor/autoload.php';

    $crud = new CRUD();
    $id_usuario = $_GET['id_usuario'];
    $password = $_GET['token'];

    function obtener_token($id_usuario){
        global $crud;
        $respuesta = $crud->query("SELECT password FROM tbl_usuarios WHERE id_usuario = $id_usuario");
        $respuesta = urldecode(substr($respuesta[0][0],29));
        return $respuesta;
    }

    function confirmar_cuenta($id_usuario){
        global $crud;
        $crud->store_procedure("CALL activacion_usuario($id_usuario)");

        return 1;
    }

    if($password != obtener_token($id_usuario)){
        echo 'Token Erroneo';
        exit();
    }

    confirmar_cuenta($id_usuario);

    echo 'Gracias por Registrarte';

    ?>
    </p>
</body>
</html>