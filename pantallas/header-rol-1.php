<?php

if(session_status() != 2){
    session_start();
}

$ruta = $_SERVER['DOCUMENT_ROOT'];

include_once "$ruta/api/crud.php";
include_once "$ruta/pantallas/incluir-librerias.php";

$id_usuario = $_SESSION['id_usuario'];

$datos_usuario = $crud->query("SELECT concat(nombre,' ',apellido) AS nombre_completo FROM vw_usuarios_activos WHERE id_usuario = $id_usuario");
$nombre_completo = $datos_usuario[0][0];
?>

<style>
    <?php include_once "$ruta/pantallas/header-estilos.css"; ?>
</style>

<header class="header">
    <a href="/home" class="titulo">
        <h1 class="titulo-h1">Turnos</h1>
    </a>

    <div class="menu">
        <?php include "$ruta/img/menu.svg"; ?>
    </div>

    <nav class="nav">
        <div class="nav-menu">
            <?php include "$ruta/img/menu-2.svg"; ?>
        </div>

        <div class="perfil">
            <img src="/api/informacion-general/foto-categoria.php?categoria=usuario&id=<?php echo $id_usuario;?>" alt="cuenta" class="perfil-foto">
            <p><?php echo $nombre_completo; ?></p>
        </div>

        <ul>
            <li><a href="/home/usuarios/predios-favoritos">Predios Favoritos</a></li>
            <li><a href="/home/usuarios/actividades-favoritas">Actividades Favoritas</a></li>
            <li><a href="/home/usuarios/turnos-usuario">Tus Turnos</a></li>
        </ul>

        <ul>
            <li><a href="/cuenta/actualizar-usuario">Configurar Cuenta</a></li>
            <li id="cerrar_sesion">Cerrar Sesion</li>
        </ul>

        <ul class="extra">
            <li><a href="/">Inicio</a></li>
            <li><a href="/extra/contacto">Contacto</a></li>
            <li><a href="/extra/creditos">Creditos</a></li>
        </ul>
    </nav>

    <form action="/home/buscador/" id="buscador" method="GET" class="buscador">
        <input type="input" placeholder="Buscar Predio o Actividad...">
        <img src="/img/lupa.png" alt="Buscar" class="lupa">
    </form>

    <div class="perfil" id="cuenta">
        <img src="/api/informacion-general/foto-categoria.php?categoria=usuario&id=<?php echo $id_usuario;?>" alt="cuenta" class="perfil-foto">
        <p><?php echo $nombre_completo; ?></p>
    </div>

    <div class="pantalla-transparente"></div>
</header>

<script>
    <?php include_once "$ruta/pantallas/header-script.js"; ?>
</script>