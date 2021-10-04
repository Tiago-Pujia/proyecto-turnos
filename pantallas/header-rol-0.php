<?php 
$ruta = $_SERVER['DOCUMENT_ROOT']; 
include_once "$ruta/pantallas/incluir-librerias.php";
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
            <img src="/img/perfil-predeterminado.png" alt="cuenta" class="perfil-foto">
            <p>Perfil</p>
        </div>

        <ul class="crear-cuenta">
            <li><a href="/cuenta/iniciar-sesion/">Iniciar Sesion</a></li>
            <li><a href="/cuenta/registrarte-usuario/">Registrarte</a></li>
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
        <img src="/img/perfil-predeterminado.png" alt="cuenta" class="perfil-foto">
        <p>Perfil</p>
    </div>

    <div class="pantalla-transparente"></div>
</header>

<script>
    <?php include_once "$ruta/pantallas/header-script.js"; ?>
</script>