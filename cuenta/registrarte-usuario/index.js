const pintar_mensaje = (message, color) => {
    $("form .mensaje").html(message).css("color", color);
    return true;
};

const pintar_errores_campos = (arr_campos) => {
    $("fieldset").find(".error_campo").remove();

    for (let value0 in arr_campos) {
        let nodo = $(`input[name="${value0}"]`).parents("fieldset");

        for (let value1 in arr_campos[value0]) {
            nodo.append(
                $("<p>")
                    .text(arr_campos[value0][value1])
                    .addClass("error_campo")
            );
        }
    }

    if (Object.keys(arr_campos).length) {
        pintar_mensaje("Error","#ff0000");
    } else {
        pintar_mensaje("Registrado Correctamente, ahora puede <a href='/cuenta/iniciar-sesion/'>Iniciar sesion</a>.<br>Por favor mire su correo electronico para verificar su cuenta","#1dd1a1");
    }

    return true;
};

$("#formLogin").submit(function (el) {
    el.preventDefault();

    pintar_mensaje('Cargando...','#7f8c8d');
    
    $("#formLogin input[name]").val(function () {
        return this.value.trim();
    });

    if ($("#password_confirmado").val() == '' || $("#password").val() != $("#password_confirmado").val()) {
        pintar_mensaje("Error", "#ff0000");
        pintar_errores_campos({password_confirmado: ['Las contraseñas no son iguales']})
        return true;
    }

    let information = $(this).serialize();

    $.ajax({
        type: "GET",
        url: "/api/cuenta/crear-cuenta-usuario.php",
        dataType: "json",
        data: information,
        success(response){
            pintar_errores_campos(response);
        }
    });
});