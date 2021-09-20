const pintar_mensaje = (message, color) => {
    $("form .mensaje").html(message).css("color", color);
    return true;
};

$("#formLogin").submit(function (el) {
    el.preventDefault();

    pintar_mensaje("Cargando...", "#7f8c8d");

    let informacion = {
        email: $('#email').val().trim()
    };

    $.ajax({
        type: "GET",
        url: "/api/cuenta/olvide-contrasena-enviar-correo.php",
        data: informacion,
        success(respuesta) {
            if (respuesta == 1) {
                pintar_mensaje("Verifique su correo electronico para cambiar su contraseña","#1dd1a1");
                return true;
            }

            pintar_mensaje(respuesta,"#ff0000");
            return true;
        },
    });
});
