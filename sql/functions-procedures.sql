/*
Funciones a crear:
Bajaria el nivel de optimizacion, no crear.
    * actualizar_usuario(id_usuario INT, nombre VARCHAR(200), apellido VARCHAR(100), fecha_nacimiento(DATE), sexo VARCHAR(1), email VARCHAR(200), password VARCHAR(500), foto_perfil MEDIUMBLOB)
    * actualizar_usuario_ultimo_ingreso(id_usuario INT)
    * actualizar_predio(id_predio INT, nombre VARCHAR(400), email VARCHAR(200), password VARCHAR(500), descripcion VARCHAR())
    * actualizar_Actividad(id_actividad INT, nombre_actividad VARCHAR(200), telefono VARCHAR(100), usuarios_maximos_x_turno SMALLINT, descripcion VARCHAR(10000), foto_actividad MEDIUMBLOB)

    * eliminar_predio_anuncio
    * eliminar_predio_comentario
    * eliminar_actividad_comentario
    * eliminar_actividad_anuncio
    * eliminar_actividad_administrador
    * eliminar_activdad_horario
    * eliminar_activdad_dias_cerrados
*/

DELIMITER //

CREATE PROCEDURE baja_turno(id_turno INT)
BEGIN
    UPDATE tbl_turnos SET fecha_baja = now() WHERE  id_turno = id_turno;
END//

CREATE PROCEDURE baja_actividades (id_actividad INT)
BEGIN
    DECLARE campo_id INT UNSIGNED;
    DECLARE cursor_listo BIT DEFAULT 0;
    DECLARE cursor_1 CURSOR FOR
        SELECT id_usuario FROM tbl_administradores_x_predio WHERE id_actividad = id_actividad;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cursor_listo = 1;

    START TRANSACTION;

        UPDATE tbl_turnos SET fecha_baja = now() WHERE tbl_turnos.id_actividad = id_actividad;
        UPDATE tbl_actividades SET fecha_baja = now() WHERE tbl_actividades.id_actividad = id_actividad;
        UPDATE tbl_administradores_x_predio SET fecha_baja = now() WHERE tbl_administradores_x_predio.id_actividad = id_actividad;

        OPEN cursor_1;
            ciclo_1: LOOP
                FETCH cursor_1 INTO campo_id;
                IF (cursor_listo = 1) THEN 
                    LEAVE ciclo_1;
                END IF;

                IF(
                    (SELECT id_predio FROM tbl_predios WHERE id_predio.id_propietario = campo_id AND fecha_baja IS NOT NULL)IS NULL OR
                    (SELECT id_administrador FROM tbl_administradores_x_predio WHERE id_administrador.id_usuario = campo_id AND fecha_baja IS NOT NULL)IS NULL
                ) THEN
                    UPDATE tbl_usuarios SET id_rol = 1 WHERE id_usuario = campo_id;
                END IF;

            END LOOP ciclo_1;
        CLOSE cursor_1;

    COMMIT;
END//


CREATE PROCEDURE baja_predio (id_predio INT)
BEGIN
    DECLARE campo_id INT UNSIGNED;
    DECLARE cursor_listo BIT DEFAULT 0;
    DECLARE cursor_1 CURSOR FOR
        SELECT id_usuario FROM tbl_administradores_x_predio WHERE tbl_administradores_x_predio.id_predio = id_predio;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cursor_listo = 1;

    START TRANSACTION;
        UPDATE tbl_turnos SET fecha_baja = now() WHERE tbl_turnos.id_predio = id_predio;
        UPDATE tbl_actividades SET fecha_baja = now() WHERE tbl_actividades.id_predio = id_predio;
        UPDATE tbl_predios SET fecha_baja = now() WHERE tbl_predios.id_predio = id_predio;
        UPDATE tbl_administradores_x_predio SET fecha_baja = now() WHERE tbl_administradores_x_predio.id_predio = id_predio;

        
        OPEN cursor_1;
            ciclo_1: LOOP
                FETCH cursor_1 INTO campo_id;
                IF (cursor_listo = 1) THEN 
                    LEAVE ciclo_1;
                END IF;

                IF(
                    (SELECT id_predio FROM tbl_predios WHERE tbl_predios.id_propietario = campo_id AND fecha_baja IS NOT NULL)IS NULL OR
                    (SELECT id_administrador FROM tbl_administradores_x_predio WHERE tbl_administradores_x_predio.id_usuario = campo_id AND fecha_baja IS NOT NULL)IS NULL
                ) THEN
                    UPDATE tbl_usuarios SET id_rol = 1 WHERE tbl_usuarios.id_usuario = campo_id;
                END IF;

            END LOOP ciclo_1;
        CLOSE cursor_1;
    COMMIT;
END//

CREATE PROCEDURE baja_usuario(id_usuario INT)
BEGIN
    DECLARE campo_predio INT UNSIGNED;
    DECLARE cursor_listo BIT DEFAULT 0;
    DECLARE cursor_1 CURSOR FOR
        SELECT id_usuario FROM tbl_administradores_x_predio WHERE tbl_administradores_x_predio.id_predio = id_predio;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cursor_listo = 1;

    -- baja_predio

    START TRANSACTION;
        UPDATE tbl_turnos SET fecha_baja = now() WHERE id_usuario = id_usuario;
        UPDATE tbl_usuarios SET fecha_baja = now() WHERE id_usuario = id_usuario;
        UPDATE tbl_administradores_x_predio SET fecha_baja = now() WHERE id_usuario = id_usuario;

        OPEN cursor_1;
            ciclo_1: LOOP
                FETCH cursor_1 INTO campo_predio;
                IF (cursor_listo = 1) THEN 
                    LEAVE ciclo_1;
                END IF;

                CALL baja_predio(campo_predio);

            END LOOP ciclo_1;
        CLOSE cursor_1;
    COMMIT;
END//


CREATE PROCEDURE baja_administrador (id_administrador INT)
BEGIN
    DECLARE id_usuario INT UNSIGNED;
    SET id_usuario = (SELECT id_usuario FROM tbl_administradores_x_predio WHERE id_administrador = id_administrador);

    UPDATE
        tbl_administradores_x_predio
    SET 
        fecha_baja = now()
    WHERE
        id_administrador = id_administrador;

    IF(
        (SELECT id_predio FROM tbl_predios WHERE tbl_predios.id_propietario = id_usuario AND fecha_baja IS NOT NULL)IS NULL OR
        (SELECT id_administrador FROM tbl_administradores_x_predio WHERE tbl_administradores_x_predio.id_usuario = id_usuario AND fecha_baja IS NOT NULL)IS NULL
    ) THEN
        UPDATE tbl_usuarios SET id_rol = 2 WHERE tbl_usuarios.id_usuario = id_usuario;
    END IF;
END//


CREATE FUNCTION insertar_turno(id_usuario INT, id_predio INT, id_actividad INT, id_horario INT, fecha DATE)
RETURNS VARCHAR(100)
BEGIN
    SET @turnos_maximos = (SELECT usuarios_maximos_x_turno FROM tbl_actividades WHERE tbl_actividades.id_actividad = id_actividad),
        @cantidad_turnos = (SELECT count(id_turno) FROM tbl_turnos WHERE tbl_turnos.id_actividad = id_actividad AND tbl_turnos.fecha = fecha );

    IF (@cantidad_turnos >= @turnos_maximos) THEN
        RETURN '{"mensaje":"Turnos Llenos"}';
    END IF;

    SET @nombre_dia_horario = (SELECT tbl_nombres_dias.dia FROM tbl_actividades_horarios_semanales INNER JOIN tbl_nombres_dias ON tbl_nombres_dias.id_dia = tbl_actividades_horarios_semanales.dia WHERE tbl_actividades_horarios_semanales.id_horario = id_horario);

    IF(DAYNAME(fecha) != (@nombre_dia_horario)) THEN
        RETURN '{"mensaje":"El dia no encaja con el turno"}';
    END IF;

    IF((SELECT COUNT(id_usuario) FROM tbl_turnos WHERE tbl_turnos.id_usuario = id_usuario AND tbl_turnos.id_actividad = id_actividad AND tbl_turnos.id_horario = id_horario LIMIT 1) = 1) THEN
        RETURN '{"mensaje":"Ya tomaste este turno"}';
    END IF;

    INSERT INTO
        tbl_turnos (id_usuario,id_predio,id_actividad,id_horario,fecha)
    VALUES
        (id_usuario,id_predio,id_actividad,id_horario,fecha);
    
    RETURN '1';
END//

CREATE FUNCTION insertar_usuario (nombre VARCHAR(200), apellido VARCHAR(100), fecha_nacimiento DATE, sexo BIT, email VARCHAR(200), password VARCHAR(500))
RETURNS VARCHAR(100)
BEGIN
    INSERT INTO
        tbl_usuarios (nombre,apellido,fecha_nacimiento,sexo,email,password)
    VALUES
        (
            nombre,
            apellido,
            fecha_nacimiento,
            sexo,
            email,
            password
        );

    RETURN '1';
END//

CREATE FUNCTION insertar_predio (id_propietario INT,email VARCHAR(200),nombre VARCHAR(400), telefono VARCHAR(100),descripcion VARCHAR(10000), provincia VARCHAR(200),localidad VARCHAR(200),direccion VARCHAR(1000))
RETURNS VARCHAR(200)
BEGIN
    INSERT INTO
        tbl_predios (id_propietario,email,nombre,telefono,descripcion,provincia,localidad,direccion)
    VALUES
        (
            id_propietario,
            email,
            nombre,
            telefono,
            descripcion,
            provincia,
            localidad,
            direccion
        );
    
    UPDATE
        tbl_usuarios
    SET
        id_rol = 2
    WHERE
        id_usuario = id_propietario;
        
    RETURN '1';
END//

CREATE FUNCTION insertar_administrador(id_usuario INT,id_predio INT,id_actividad INT)
RETURNS VARCHAR(100)
BEGIN
    INSERT INTO
        tbl_administradores_x_predio (id_usuario,id_predio,id_actividad)
    VALUES
        (
            id_usuario,
            id_predio,
            id_actividad
        );

    UPDATE
        tbl_usuarios
    SET
        id_rol = 2
    WHERE
        id_usuario = id_usuario;

    RETURN '1';
END//

CREATE FUNCTION insertar_predios_anuncios(id_predio INT,titulo VARCHAR(200),descripcion VARCHAR(10000)) 
RETURNS VARCHAR(100)
BEGIN
    INSERT INTO 
        tbl_predios_anuncios (id_predio,titulo,descripcion)
    VALUES
        (
            id_predio,
            titulo,
            descripcion
        );
    
    RETURN '1';
END//

CREATE FUNCTION insertar_predio_comentario(id_predio INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000))
RETURNS VARCHAR(10000)
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
    
    RETURN '1';
END//

CREATE FUNCTION insertar_actividad(id_predio INT,nombre_actividad VARCHAR(400),telefono VARCHAR(100),usuarios_maximos_x_turno SMALLINT,descripcion VARCHAR(10000),foto_actividad MEDIUMBLOB)
RETURNS VARCHAR(100)
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

    RETURN '1';
END//

CREATE FUNCTION insertar_actividad_anuncios(id_actividad INT,titulo VARCHAR(200),descripcion VARCHAR(10000)) 
RETURNS VARCHAR(100)
BEGIN
    INSERT INTO 
        tbl_actividades_anuncios (id_actividad,titulo,descripcion)
    VALUES
        (
            id_actividad,
            titulo,
            descripcion
        );
    
    RETURN '1';
END//

CREATE FUNCTION insertar_actividad_comentario(id_actividad INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000))
RETURNS VARCHAR(10000)
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
    
    RETURN '1';
END//

CREATE FUNCTION insertar_actividad_horario(id_actividad INT,dia INT, precio INT,hora_comienzo TIME,hora_finalizacion TIME)
RETURNS VARCHAR(100)
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

    RETURN '1';
END//

CREATE FUNCTION insertar_actividad_dia_cerrados(id_actividad INT,fecha DATE)
RETURNS VARCHAR(100)
BEGIN
    INSERT INTO 
        tbl_actividades_dias_cerrados_temporalmente(id_actividad,fecha)
    VALUES
        (id_actividad,fecha);

    RETURN '1';
END//

CREATE PROCEDURE activacion_usuario (id_usuario INT)
BEGIN
    UPDATE tbl_usuarios SET fecha_confirmacion = now() WHERE id_usuario = id_usuario;
END//

CREATE PROCEDURE activacion_usuario_de_baja(id_usuario INT)
BEGIN
    UPDATE tbl_usuarios SET fecha_baja = null WHERE id_usuario = id_usuario;
END//

CREATE PROCEDURE activacion_predio_de_baja(id_predio INT)
BEGIN
    UPDATE tbl_predios SET fecha_baja = null WHERE id_predio = id_predio;
    UPDATE tbl_usuarios SET id_rol = 2 WHERE id_usuario = (SELECT id_propietario FROM tbl_predios WHERE id_predio = id_predio);
END//

CREATE PROCEDURE activacion_actividad_de_baja(id_actividad INT)
BEGIN
    UPDATE tbl_predios SET fecha_baja = null WHERE id_actividad = id_actividad;
END//

CREATE PROCEDURE activacion_administrador_de_baja(id_administrador INT)
BEGIN
    UPDATE tbl_administradores_x_predio SET fecha_baja = null WHERE id_administrador = id_administrador;
END//

CREATE FUNCTION validar_email (email VARCHAR(200))
RETURNS VARCHAR(200)
BEGIN
    IF ((SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.email = email AND fecha_baja IS NOT NULL LIMIT 1) IS NOT NULL) THEN
        RETURN 'Diste de baja tu cuenta, revisa tu correo para volverla a activar';

    ELSEIF ((SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN 'Correo ya en uso';

    END IF;

    RETURN '1';
END//

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