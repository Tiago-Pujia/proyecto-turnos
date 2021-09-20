const pintar_mensaje = (message, color) => {
    $("form .mensaje").html(message).css("color", color);
    return true;
};

$("#formLogin").submit(function (el) {
    el.preventDefault();

    pintar_mensaje("Cargando...", "#7f8c8d");

    if ($("#password").val().trim() != $("#password_confirmado").val().trim()) {
        pintar_mensaje("Las contraseñas no son iguales", "#ff0000");
        return true;
    }

    let informacion = {
        token: new URLSearchParams(window.location.search).get("token"),
        id_usuario: new URLSearchParams(window.location.search).get(
            "id_usuario"
        ),
        nuevo_password: $("#password").val().trim(),
    };

    $.ajax({
        type: "GET",
        url: "/api/cuenta/olvide-contrasena.php",
        data: informacion,
        success(respuesta) {
            if (respuesta == 1) {
                pintar_mensaje("Contraseña cambiada correctamente","#1dd1a1");
                return true;
            }

            pintar_mensaje(respuesta,"#ff0000");
            return true;
        },
    });
});
