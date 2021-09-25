DELIMITER //

-- =========================================================================================================
-- Dar de baja
-- =========================================================================================================

CREATE PROCEDURE baja_turno(id_turno INT)
BEGIN
    UPDATE tbl_turnos AS a SET fecha_baja = now() WHERE  a.id_turno = id_turno;
END//

CREATE PROCEDURE baja_actividades (id_actividad INT)
BEGIN
    START TRANSACTION;
        UPDATE tbl_turnos SET fecha_baja = now() WHERE tbl_turnos.id_actividad = id_actividad;
        UPDATE tbl_actividades SET fecha_baja = now() WHERE tbl_actividades.id_actividad = id_actividad;
    COMMIT;
END//

CREATE PROCEDURE baja_predio (id_predio INT)
BEGIN
    START TRANSACTION;
        UPDATE tbl_turnos SET fecha_baja = now() WHERE tbl_turnos.id_predio = id_predio;
        UPDATE tbl_actividades SET fecha_baja = now() WHERE tbl_actividades.id_predio = id_predio;
        UPDATE tbl_predios SET fecha_baja = now() WHERE tbl_predios.id_predio = id_predio;
        UPDATE tbl_administradores_x_predio SET fecha_baja = now() WHERE tbl_administradores_x_predio.id_predio = id_predio;

        UPDATE
            tbl_usuarios
        SET
            id_rol = 1
        WHERE
            id_usuario IN(
                SELECT
                    tbl_usuarios.id_usuario
                FROM
                    tbl_usuarios AS a
                INNER JOIN tbl_administradores_x_predio AS b ON 
                    b.id_usuario = a.id_usuario 
                    AND b.id_usuario NOT IN (b.id_predio != id_predio) 
                    AND b.id_predio = id_predio 
                    AND b.fecha_baja IS NOT NULL 
                    AND a.id_rol NOT IN(3, 4)
            );
    COMMIT;
END//

CREATE PROCEDURE baja_usuario(id_usuario INT)
BEGIN
    START TRANSACTION;
        UPDATE tbl_turnos AS a SET fecha_baja = now() WHERE a.id_usuario = id_usuario;
        UPDATE tbl_usuarios AS a  SET fecha_baja = now() WHERE a.id_usuario = id_usuario;
        UPDATE tbl_administradores_x_predio AS a SET fecha_baja = now() WHERE a.id_usuario = id_usuario;
    COMMIT;
END//

CREATE PROCEDURE baja_administrador_x_predio (id_administrador INT)
BEGIN
    DECLARE id_usuario INT UNSIGNED;
    SET id_usuario = (SELECT id_usuario FROM tbl_administradores_x_predio WHERE tbl_administradores_x_predio.id_administrador = id_administrador);

    UPDATE tbl_administradores_x_predio AS a SET fecha_baja = now() WHERE a.id_administrador = id_administrador;
    UPDATE tbl_administradores_x_actividad AS a SET  fecha_baja = now() WHERE a.id_administrador = id_administrador;

    IF(
        (SELECT ' ' FROM tbl_administradores_x_predio AS a WHERE a.id_usuario = id_usuario AND fecha_baja IS NOT NULL)IS NULL AND
        (SELECT ' ' FROM tbl_usuarios AS a WHERE a.id_usuario = id_usuario AND tbl_usuarios.id_rol IN(3,4)) IS NULL
    ) THEN
        UPDATE tbl_usuarios AS a SET id_rol = 1 WHERE a.id_usuario = id_usuario;
    END IF;
END//

CREATE PROCEDURE baja_administrador_x_actividad(id_administrador INT,id_actividad INT)
BEGIN
    UPDATE 
        tbl_administradores_x_actividad AS a
    SET 
        fecha_baja = now() 
    WHERE 
        a.id_administrador = id_administrador AND 
        a.id_actividad = id_actividad;
END//

CREATE PROCEDURE baja_predio_propietario (id_propietario INT)
BEGIN
    UPDATE
        tbl_predios_propietarios
    SET
        fecha_baja = now()
    WHERE
        tbl_predios_propietarios.id_propietario = id_propietario;
END//

-- =========================================================================================================
-- Insertar Registro Principales
-- =========================================================================================================

CREATE PROCEDURE insertar_turno(id_usuario INT, id_predio INT, id_actividad INT, id_horario INT, fecha DATE)
BEGIN
    INSERT INTO
        tbl_turnos (id_usuario,id_predio,id_actividad,id_horario,fecha)
    VALUES
        (
            id_usuario,
            id_predio,
            id_actividad,
            id_horario,
            fecha
        );
END//

CREATE PROCEDURE insertar_predio (id_propietario INT,email VARCHAR(200),nombre VARCHAR(400), telefono VARCHAR(100),descripcion VARCHAR(10000), provincia VARCHAR(200),localidad VARCHAR(200),direccion VARCHAR(1000))
BEGIN
    INSERT INTO
        tbl_predios (nombre,email,telefono,descripcion,provincia,localidad,direccion)
    VALUES
        (
            nombre,
            email,
            telefono,
            descripcion,
            provincia,
            localidad,
            direccion
        );
    
    IF ((SELECT id_rol FROM vw_usuarios_activos WHERE id_usuario = id_propietario) != (3,4)) THEN
        UPDATE tbl_usuarios SET id_rol = 3 WHERE id_usuario = id_propietario;
    END IF;
    
    INSERT INTO 
        tbl_predios_propietarios (id_predio,id_usuario) 
    VALUES 
        (
            (SELECT id_predio FROM tbl_predios WHERE tbl_predios.email = email),
            id_propietario
        );
END//

CREATE PROCEDURE insertar_administrador(id_usuario INT,id_predio INT,acceso_global BIT)
BEGIN
    INSERT INTO
        tbl_administradores_x_predio (id_usuario,id_predio,acceso_global_actividades)
    VALUES
        (
            id_usuario,
            id_predio,
            acceso_global
        );

    IF ((SELECT id_rol FROM vw_usuarios_activos AS a WHERE a.id_usuario = id_usuario) != (3,4)) THEN
        UPDATE vw_usuarios_activos AS a SET id_rol = 2 WHERE a.id_usuario = id_usuario;
    END IF;
END//

CREATE PROCEDURE insertar_administrador_actividades(id_administrador INT, id_actividad INT)
BEGIN
    INSERT INTO
        tbl_administradores_x_actividad (id_administrador, id_actividad)
    VALUES
        (
            id_administrador, 
            id_actividad
        );
END//

CREATE PROCEDURE insertar_predio_propietario(id_predio INT, id_usuario INT)
BEGIN
    INSERT INTO 
        tbl_predios_propietarios(id_predio, id_usuario)
    VALUES
        (
            id_predio, 
            id_usuario
        );
END//

CREATE PROCEDURE insertar_usuario_predio_favorito(id_usuario INT,id_predio INT)
BEGIN
    INSERT INTO
        tbl_predios_favoritos_usuarios (id_usuario,id_predio)
    VALUES
        (
            id_usuario,
            id_predio
        );
END//

CREATE PROCEDURE insertar_usuario_actividad_favorito(id_usuario INT,id_actividad INT)
BEGIN
    INSERT INTO
        tbl_actividades_favoritos_usuarios (id_usuario,id_actividad)
    VALUES
        (
            id_usuario,
            id_actividad
        );
END//

-- =========================================================================================================
-- Insertar Registros Secundarios
-- =========================================================================================================

CREATE PROCEDURE insertar_predios_anuncios(id_predio INT,titulo VARCHAR(200),descripcion VARCHAR(10000)) 
BEGIN
    INSERT INTO 
        tbl_predios_anuncios (id_predio,titulo,descripcion)
    VALUES
        (
            id_predio,
            titulo,
            descripcion
        );
END//

CREATE PROCEDURE insertar_predio_comentario(id_predio INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000))
BEGIN
    INSERT INTO
        tbl_predio_comentarios (id_predio,id_usuario,anonimo,calificacion,comentario)
    VALUES
        (
            id_predio,
            id_usuario,
            anonimo,
            calificacion,
            comentario
        );
END//

CREATE PROCEDURE insertar_actividad(id_predio INT,nombre_actividad VARCHAR(400),telefono VARCHAR(100),usuarios_maximos_x_turno SMALLINT,descripcion VARCHAR(10000),foto_actividad MEDIUMBLOB)
BEGIN
    INSERT INTO
        tbl_actividades (id_predio,nombre_actividad,telefono,usuarios_maximos_x_turno,descripcion,foto_actividad)
    VALUES
    (
        id_predio,
        nombre_actividad,
        telefono,
        usuarios_maximos_x_turno,
        descripcion,
        foto_actividad
    );
END//

CREATE PROCEDURE insertar_actividad_anuncios(id_actividad INT,titulo VARCHAR(200),descripcion VARCHAR(10000)) 
BEGIN
    INSERT INTO 
        tbl_actividades_anuncios (id_actividad,titulo,descripcion)
    VALUES
        (
            id_actividad,
            titulo,
            descripcion
        );
END//

CREATE PROCEDURE insertar_actividad_comentario(id_actividad INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000))
BEGIN
    INSERT INTO
        tbl_predio_comentarios (id_actividad,id_usuario,anonimo,calificacion,comentario)
    VALUES
        (
            id_actividad,
            id_usuario,
            anonimo,
            calificacion,
            comentario
        );
END//

CREATE PROCEDURE insertar_actividad_horario(id_actividad INT,dia INT, precio INT,hora_comienzo TIME,hora_finalizacion TIME)
BEGIN
    -- IF (TIMEDIFF(hora_finalizacion,hora_comienzo) <= 0) THEN
    --     RETURN '{"mensaje":"Hora de finalizacion incorrecto"}';
    -- END IF;

    INSERT INTO
        tbl_actividades_horarios_semanales (id_actividad,dia,precio,hora_comienzo,hora_finalizacion)
    VALUES
        (
            id_actividad,
            dia,
            precio,
            hora_comienzo,
            hora_finalizacion
        );
END//

CREATE PROCEDURE insertar_actividad_dia_cerrados(id_actividad INT,fecha DATE)
BEGIN
    INSERT INTO 
        tbl_actividades_dias_cerrados_temporalmente(id_actividad,fecha)
    VALUES
        (
            id_actividad,
            fecha
        );
END//

-- =========================================================================================================
-- Activacion de Registros
-- =========================================================================================================

CREATE PROCEDURE activacion_predio_de_baja(id_predio INT)
BEGIN
    UPDATE tbl_predios AS a SET fecha_baja = null WHERE a.id_predio = id_predio;
END//

CREATE PROCEDURE activacion_actividad_de_baja(id_actividad INT)
BEGIN
    UPDATE tbl_actividades AS a SET fecha_baja = null WHERE a.id_actividad = id_actividad;
END//

CREATE PROCEDURE activacion_administrador_de_baja(id_administrador INT)
BEGIN
    UPDATE tbl_administradores_x_predio AS a SET fecha_baja = null WHERE a.id_administrador = id_administrador;
END//

-- =========================================================================================================
-- Extras
-- =========================================================================================================

CREATE PROCEDURE insert_log (tabla VARCHAR(100),campo_modificado VARCHAR(100),id INT,valor_nuevo VARCHAR(10000),valor_viejo VARCHAR(10000))
BEGIN
    INSERT INTO 
        tbl_logs (tabla,campo_modificado,id,valor_nuevo,valor_viejo) 
    VALUES 
        (
            tabla,
            campo_modificado,
            id,
            valor_nuevo,
            valor_viejo
        );
END//

DELIMITER ;