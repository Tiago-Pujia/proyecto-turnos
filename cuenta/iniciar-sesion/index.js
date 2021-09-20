const pintar_mensaje = (message, color) => {
    $("form .mensaje").html(message).css("color", color);
    return true;
};

const check_session = () => {
    $.get(
        "/api/cuenta/comprobar-sesion-creada.php",
        (response) => {
            pintar_mensaje(
                Number(response)
                    ? "Ya se encuentra en una sesion, estas seguro de cerrarla?"
                    : ""
                ,
                '#7f8c8d'
            );
        }
    );
};

$("#formLogin").submit(function (el) {
    el.preventDefault();

    pintar_mensaje('Cargando...','#7f8c8d');

    // Bloqueo de campos tras 10 intentos seguidos de inicio de sesion
    security_login(10);
    if (block_login()) return;

    // Iniciar Sesion
    $("input[name]").val(function () {
        return this.value.trim();
    });

    let informacion = $(this).serialize();

    $.ajax({
        type: "GET",
        url: "/api/cuenta/iniciar-sesion.php",
        data: informacion,
        success(respuesta){
            if (respuesta == "1") {
                location = "/";
                return respuesta;
            }
    
            pintar_mensaje(respuesta,'#ff0000');
            return respuesta;
        }
    });
});

check_session();
