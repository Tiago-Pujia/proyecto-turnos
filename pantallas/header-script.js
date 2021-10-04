$('.lupa').click(function(){
    $(this).parents('form').submit()
});

$('.menu, .nav-menu').click(()=>{
    $('.nav, .pantalla-transparente').slideToggle();
});

$('#cuenta').click(()=>{
    let nav = $('.nav'),
        header = $('.header'),
        nav_display = nav.css('display');

    if(nav.css('display') == 'none'){
        nav.slideDown()
            .css('display','flex');
        header.css('border-bottom','none')
    } else {
        nav.slideUp();
        header.css('border-bottom','4px solid #000')
    }
});

$(window).resize((e)=> { 
    let nav = $('.nav');
    let nav_display = nav.css('display');

    if(window.innerWidth < '769'){
        if(nav_display == 'flex'){
            nav.css('display','none');
            $('.header').css('border-bottom','4px solid #000');
        };
        
    } else if(window.innerWidth > '769'){
        if(nav_display == 'block'){
            nav.css('display','none')
            $('.pantalla-transparente').css('display','none')
        };
    };
});

$('#cerrar_sesion').click(()=>{
    $.ajax({
        type: "get",
        url: "/api/informacion-general/usuario.php?peticion=cerrar-sesion",
    })
        .done(()=>{
            let cookies = Object.keys($.cookie());

            cookies.forEach(el => {
                $.removeCookie(el, { path: '/' });
            });
        })

        .done(()=>{
            window.location.reload();
        })
    ;
});