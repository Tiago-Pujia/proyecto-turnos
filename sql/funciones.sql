DELIMITER //

CREATE FUNCTION validar_email (email VARCHAR(200))
RETURNS VARCHAR(200)
READS SQL DATA
BEGIN
    DECLARE correo_en_uso VARCHAR(100);
    DECLARE  cuenta_de_baja VARCHAR(200);

    SET correo_en_uso = (SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.email = email AND fecha_baja IS NOT NULL LIMIT 1),
        cuenta_de_baja = (SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.email = email LIMIT 1);

    IF (correo_en_uso IS NOT NULL) THEN
        RETURN 'Diste de baja tu cuenta, revisa tu correo para volverla a activar';
    ELSEIF (cuenta_de_baja IS NOT NULL) THEN
        RETURN 'Correo ya en uso';
    END IF;

    RETURN '1';
END//

CREATE FUNCTION validar_insertar_turno (id_usuario INT, id_actividad INT, id_horario INT, fecha DATE)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE turnos_maximos INT UNSIGNED;
    DECLARE cantidad_turnos INT UNSIGNED;
    DECLARE nombre_dia_horario VARCHAR(100);

    SET turnos_maximos = (SELECT usuarios_maximos_x_turno FROM tbl_actividades AS a WHERE a.id_actividad = id_actividad),
        cantidad_turnos = (SELECT count(id_turno) FROM tbl_turnos AS a WHERE a.id_actividad = id_actividad AND a.fecha = fecha),
        nombre_dia_horario = (SELECT b.dia FROM tbl_actividades_horarios_semanales AS a INNER JOIN tbl_nombres_dias AS b ON b.id_dia = a.dia WHERE a.id_horario = id_horario);

    IF (cantidad_turnos >= turnos_maximos) THEN
        RETURN 'Turnos Llenos';
    END IF;

    IF(DAYNAME(fecha) != nombre_dia_horario) THEN
        RETURN 'El dia no encaja con el turno';
    END IF;

    IF(
        (
            SELECT 
                COUNT(id_usuario) 
            FROM 
                tbl_turnos AS a 
            WHERE 
                    a.id_usuario = id_usuario 
                AND a.id_actividad = id_actividad 
                AND a.id_horario = id_horario 
            LIMIT 1
        ) = 1
    ) THEN
        RETURN 'Ya tomaste este turno';
    END IF;

    RETURN '1';
END//

DELIMITER ;