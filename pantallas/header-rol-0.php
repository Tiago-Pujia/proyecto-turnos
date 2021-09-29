<style>
    <?php include_once 'header-estilos.css'; ?>
</style>

<header class="header">
    <a href="/home" class="titulo">
        <h1 class="titulo-h1">Turnos</h1>
    </a>

    <div class="menu">
        <?php include '../img/menu.svg'; ?>
    </div>

    <nav class="nav">
        <div class="nav-menu">
            <?php include '../img/menu-2.svg'; ?>
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
    $('.lupa').click(function(){
        $(this).parents('form').submit()
    });

    $('.menu, .nav-menu').click(()=>{
        $('.nav, .pantalla-transparente').slideToggle();
    });

    $('#cuenta').click(()=>{
        let nav = $('.nav'),
            header = $('.header');

        if(nav.css('display') == 'none'){
            nav.slideDown()
                .css('display','flex');
            header.css('border-bottom','none')
        } else {
            nav.slideUp();
            header.css('border-bottom','4px solid #000')
        }
    })
</script>