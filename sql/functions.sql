/* 
    baja_usuario() - dar de baja un usuario cliente, parametro el id_usuario
    insertar_usuario() - subir un datos a tabla de usuarios sin confirmar, parametros: nombre, apellido, fecha_nacimiento, sexo, email, password

    baja_turno() - dar de baja un turno, parametro id_turno
    insertar_turno() - insertamos un turno, los parametros son los siguientes: id_usuario INT, id_predio INT, id_actividad INT, id_horario INT

    baja_predio() - dar de baja un predio, parametro id_predio
    
    baja_actividades() - dar de baja una actividad de un predio, parametro id_actividad

    crear:
    * usuario_activacion()
    * insertar_usuario_foto()
    * insertar_usuario_correo_activado()

    * insertar_predio()
    * insertar_predios_anuncios()
    * insertar_predio_comentario()

    * insertar_actividad()
    * insertar_actividad_anuncio()
    * insertar_actividades_administradores()
    * insertar_actividad_comentario()
    * insertar_actividad_horario()
    * insertar_actividad_dia_cerrados()

    crear funciones para actualizar datos
    crear funciones para activar una cuenta dada de baja

    revisar insertar_usuario, para enviar correos de activacion de cuenta
*/

DELIMITER //

CREATE FUNCTION baja_turno(id_turno INT)
RETURNS INT
BEGIN
    INSERT INTO 
        tbl_baja_turnos
        SELECT 
            id_turno,id_usuario,id_predio,id_actividad,id_horario,fecha_creacion,now()
        FROM 
            tbl_turnos
        WHERE 
            tbl_turnos.id_turno = id_turno;

    DELETE FROM tbl_turnos WHERE tbl_turnos.id_turno = id_turno;

    RETURN 1;
END//

CREATE FUNCTION baja_usuario(id_usuario INT)
RETURNS INT
BEGIN
    INSERT INTO 
        tbl_baja_turnos
        SELECT 
            id_turno,id_usuario,id_predio,id_actividad,id_horario,fecha_creacion,now()
        FROM 
            tbl_turnos
        WHERE 
            tbl_turnos.id_usuario = id_usuario;
    
    -- DELETE FROM tbl_turnos WHERE tbl_turnos.id_usuario = id_usuario;
    -- DELETE FROM tbl_predio_comentarios WHERE tbl_predio_comentarios.id_usuario = id_usuario;
    -- DELETE FROM tbl_administradores WHERE tbl_administradores.id_usuario = id_usuario;

    INSERT INTO 
        tbl_baja_usuarios
        SELECT 
            id_usuario,nombre,apellido,fecha_nacimiento,sexo,email,password,email_confirmado,fecha_creacion, now()
        FROM 
            tbl_usuarios 
        WHERE 
            tbl_usuarios.id_usuario = id_usuario;

    DELETE FROM tbl_usuarios WHERE tbl_usuarios.id_usuario = id_usuario;

    RETURN 1;
END//

CREATE FUNCTION baja_actividades (id_actividad INT)
RETURNS INT
BEGIN
    -- DELETE FROM tbl_turnos WHERE tbl_turnos.id_actividad = id_actividad;
    -- DELETE FROM tbl_actividades_comentarios WHERE tbl_actividades_comentarios.id_actividad = id_actividad;
    -- DELETE FROM tbl_actividades_comentarios_anonimos WHERE tbl_actividades_comentarios_anonimos.id_actividad = id_actividad;
    -- DELETE FROM tbl_actividades_anuncios WHERE tbl_actividades_anuncios.id_actividad = id_actividad;
    -- DELETE FROM tbl_actividades_dias_cerrados_temporalmente WHERE tbl_actividades_dias_cerrados_temporalmente.id_actividad = id_actividad;
    -- DELETE FROM tbl_actividades_horarios_semanales WHERE tbl_actividades_horarios_semanales.id_actividad = id_actividad;

    INSERT INTO 
        tbl_baja_turnos
        SELECT 
            id_turno,id_usuario,id_predio,id_actividad,id_horario,fecha_creacion,now()
        FROM 
            tbl_turnos
        WHERE 
            tbl_turnos.id_actividad = id_actividad;

    INSERT INTO 
        tbl_baja_actividades
        SELECT 
            id_actividad,id_predio,nombre_actividad,telefono,usuarios_maximos_x_turno,descripcion,fecha_creacion,now()
        FROM 
            tbl_actividades
        WHERE 
            tbl_actividades.id_actividad = id_actividad;

    DELETE FROM tbl_actividades WHERE tbl_actividades.id_actividad = id_actividad;

    RETURN 1;
END//

CREATE FUNCTION baja_predio (id_predio INT)
RETURNS INT
BEGIN
    INSERT INTO 
        tbl_baja_turnos
        SELECT 
            id_turno,id_usuario,id_predio,id_actividad,id_horario,fecha_creacion,now()
        FROM 
            tbl_turnos
        WHERE 
            tbl_turnos.id_predio = id_predio;

    INSERT INTO 
        tbl_baja_actividades
        SELECT 
            id_actividad,id_predio,nombre_actividad,telefono,usuarios_maximos_x_turno,descripcion,fecha_creacion,now()
        FROM 
            tbl_actividades
        WHERE 
            tbl_actividades.id_predio = id_predio;

    INSERT INTO 
        tbl_baja_predios
        SELECT 
            id_predio,nombre,email,password,descripcion,localidad,direccion,email_confirmado,fecha_creacion,fecha_baja,now()
        FROM 
            tbl_predios
        WHERE 
            tbl_predios.id_predio = id_predio;

    DELETE FROM tbl_predios WHERE tbl_predios = id_predio;

    RETURN 1;
END//

CREATE FUNCTION insertar_turno(id_usuario INT, id_predio INT, id_actividad INT, id_horario INT)
RETURNS VARCHAR(100)
BEGIN
    SET @turnos_maximos = (SELECT usuarios_maximos_x_turno FROM tbl_actividades WHERE tbl_actividades.id_actividad = id_actividad),
        @cantidad_turnos = (SELECT count(id_turno) FROM tbl_turnos WHERE tbl_turnos.id_actividad = id_actividad);

    IF (@cantidad_turnos >= @turnos_maximos) THEN
        RETURN 'Turnos Llenos';
    END IF;


    SET @mismo_turno_usuario_tomado = (SELECT COUNT(id_usuario) FROM tbl_turnos WHERE tbl_turnos.id_usuario = id_usuario AND tbl_turnos.id_actividad = id_actividad AND tbl_turnos.id_horario = id_horario LIMIT 1);

    IF(@mismo_turno_usuario_tomado = 1) THEN
        RETURN 'Ya tomaste este turno';
    END IF;


    INSERT INTO
        tbl_turnos (id_usuario,id_predio,id_actividad,id_horario)
    VALUES
        (id_usuario,id_predio,id_actividad,id_horario);
    
    RETURN '1';
END//

CREATE FUNCTION insertar_usuario (nombre VARCHAR(200), apellido VARCHAR(100), fecha_nacimiento DATE, sexo ENUM('H','M'), email VARCHAR(200), password VARCHAR(500))
RETURNS VARCHAR(1000)
BEGIN
    SET @message = '[';

    IF (length(nombre) <= 2) THEN
        SET @message = CONCAT(@message,'{"message":"Campo incompleto","field":"nombre"},');
    END IF;

    IF (length(nombre) >= 200) THEN
        SET @message = CONCAT(@message,'{"message":"Cantidad de caracteres maximos alcanzados","field":"nombre"},');
    END IF;

    IF (length(apellido) <= 2) THEN
        SET @message = CONCAT(@message,'{"message":"Campo incompleto","field":"apellido"},');
    END IF;

    IF (length(apellido) >= 100) THEN
        SET @message = CONCAT(@message,'{"message":"Cantidad de caracteres maximos alcanzados","field":"apellido"},');
    END IF;

    IF (length(email) <= 2) THEN
        SET @message = CONCAT(@message,'{"message":"Campo incompleto","field":"email"},');
    END IF;

    IF (length(email) >= 200) THEN
        SET @message = CONCAT(@message,'{"message":"Cantidad de caracteres maximos alcanzados","field":"email"},');
    END IF;
    
    IF ((SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.email = email) IS NOT NULL) THEN
        SET @message = CONCAT(@message,'{"message":"Correo ya en uso","field":"email"},');
    END IF;

    IF ((SELECT id_usuario FROM tbl_usuarios_sin_confirmar WHERE tbl_usuarios_sin_confirmar.email = email) IS NOT NULL) THEN
        SET @message = CONCAT(@message,'{"message":"Revise su correo","field":"email"},');
    END IF;

    IF ((SELECT id_usuario FROM tbl_baja_usuarios WHERE tbl_baja_usuarios.email = email) IS NOT NULL) THEN
        SET @message = CONCAT(@message,'{"message":"Diste de baja tu cuenta, revisa tu correo para volverla a activar","field":"email"},');
    END IF;

    IF(length(@message) >= 2) THEN
        SET @length = length(@message),
            @message = SUBSTRING(@message,1,@length-1),
            @message = CONCAT(@message,']');

        RETURN @message;
    ELSE
        INSERT INTO
            tbl_usuarios_sin_confirmar (nombre,apellido,fecha_nacimiento,sexo,email,password)
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
    END IF;
END//

-- CREATE FUNCTION usuario_activacion

DELIMITER ;