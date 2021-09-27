<?php

if(!isset($_GET['categoria']) || !isset($_GET['id'])) {
    exit('Datos Faltantes');
}

header('Content-Type: png');

$categoria = $_GET['categoria'];
$id = $_GET['id'];

include_once '../crud.php';


switch ($categoria) {
    case 'usuario':
        $foto = $crud->query("SELECT foto_perfil FROM vw_usuarios_activos WHERE id_usuario = $id");

        if(empty($foto)){
            echo file_get_contents('http://' . $_SERVER['SERVER_NAME'] . '/img/perfil-predeterminado.png');
        }

        echo $foto[0][0];

        break;

    case 'predio':
        $foto = $crud->query("SELECT foto_logo FROM vw_predios_activos WHERE id_predio = $id");

        if(empty($foto)){
            echo file_get_contents('http://' . $_SERVER['SERVER_NAME'] . '/img/predio-predeterminado.png');
        }

        echo $foto[0][0];
        break;
        
    case 'actividad':
        $foto = $crud->query("SELECT foto_actividad FROM vw_actividades_activos WHERE id_actividad = $id");

        if(empty($foto)){
            echo file_get_contents('http://' . $_SERVER['SERVER_NAME'] . '/img/actividad-predeterminado.png');
        }

        echo $foto[0][0];
        break;
}


?>