<style>
    <?php include_once 'styles.css'; ?>
</style>

<header class="header">
    <a href="/home" class="titulo"><h1 class="titulo">Turnos</h1></a>
    <div class="menu">
        <?php include '../img/menu.svg'; ?>
    </div>
    <nav class="nav">
        <div class="nav-menu">
            <?php include '../img/menu-2.svg'; ?>
        </div>
        <ul>
            <li><a href="/">Inicio</a></li>
            <li><a href="/extra/contacto">Contacto</a></li>
            <li><a href="/extra/creditos">Creditos</a></li>
        </ul>
    </nav>
    <form action="/home/buscador/" id="buscador" method="GET" class="buscador">
        <input type="input" placeholder="Buscar Predio o Actividad...">
        <img src="/img/lupa.png" alt="Buscar" class="lupa">
    </form>
    <img src="/img/perfil-predeterminado.png" alt="cuenta" class="perfil">
    <div class="nav-datos-usuario">
        <img src="/img/perfil-predeterminado.png" alt="cuenta" class="nav-datos-usuario-perfil">
        <ul>
            <li><a href="/cuenta/iniciar-sesion/">Iniciar Sesion</a></li>
            <li><a href="/cuenta/registrarte-usuario/">Registrarte</a></li>
        </ul>
    </div>
    <div class="pantalla-transparente"></div>
</header>
<div id="asd"></div>

<script>
    // $(window).ready(()=>{
    //     $(window).resize((e)=>console.log(e))
    // })
    $('.lupa').click(function(){$(this).parents('form').submit()});

    $('.menu, .nav-menu').click(()=> $('.nav, .pantalla-transparente').slideToggle());

    $('.perfil, .nav-datos-usuario').click(()=> $('.nav-datos-usuario, .pantalla-transparente').slideToggle())

    $('#asd').text(window.innerWidth)
</script>