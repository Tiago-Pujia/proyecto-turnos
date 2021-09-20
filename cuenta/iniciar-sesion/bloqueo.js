const security_login = (number_attempts) => {
    if (
        Number($.cookie("login_security")) >= number_attempts ||
        $.cookie("login_security") == "locked"
    ) {
        $.cookie("login_security", "locked");
    } else {
        $.cookie(
            "login_security",
            Number($.cookie("login_security")) + 1 || 0,
            {
                expires: 1,
                path: "/account/login",
            }
        );
    }
};

const block_login = () => {
    if ($.cookie("login_security") == "locked") {
        pintar_mensaje(
            "Numero de intentos maximos alcanzados, intente en 24 horas."
        );
        $("input").attr("disabled", "");

        return true;
    }

    return false;
};

if (!block_login()) check_session();