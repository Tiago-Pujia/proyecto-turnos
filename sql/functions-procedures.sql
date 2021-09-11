/*
=========================================================================================================
Inserción de datos primarios:
    * insertar_usuario(nombre VARCHAR, apellido VARCHAR, fecha_nacimiento DATE, sexo ENUM('H','M'), email VARCHAR, password VARCHAR) - subir un datos a tabla de usuarios sin confirmar 
    * insertar_predio(nombre VARCHAR(400),email VARCHAR(200),password VARCHAR(500),descripcion VARCHAR(2000),localidad VARCHAR(200),direccion VARCHAR(1000)) - insertamos un predio
    * insertar_actividad(id_predio INT,nombre_actividad VARCHAR(400),telefono VARCHAR(100),usuarios_maximos_x_turno SMALLINT DEFAULT 0,descripcion VARCHAR(10000),foto_actividad MEDIUMBLOB) Insertamos una actividad
    * insertar_turno(id_usuario INT, id_predio INT, id_actividad INT, id_horario INT, fecha INT) - insertamos un turno, los parametros son los siguientes
    FUNCIONES
=========================================================================================================

=========================================================================================================
Activacion de cuentas:
    * activacion_usuario(id_usuario INT) - activa la cuenta de usuario que se registro recientemente, moviendola de la tabla de usuarios sin confirmara usuarios
    * activacion_predio(id_predio INT) - activamos un predio moviendola a la tabla de predios
    FUNCIONES

    * activacion_usuario_de_baja(id_usuario INT)
    * activacion_predio_de_baja(id_predio INT)
    * activacion_actividad_de_baja(id_predio INT)
    Procesos Almacenados
=========================================================================================================

=========================================================================================================
Insercion de datos secundarios:
    * insertar_predios_anuncios(id_predio INT,titulo VARCHAR(200),descripcion VARCHAR(10000)) - lanzamos un anuncion de predio
    * insertar_predio_comentario(id_predio INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000)) - insertamos un comentario y calificacion como usuario a un predio
    
    * insertar_actividad_anuncios(id_actividad INT,titulo VARCHAR(200),descripcion VARCHAR(10000)) - Creamos un anuncion en una actividad
    * insertar_actividad_comentario(id_actividad INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000)) - Insertamos un comentario y calificacion acerca de la actividad
    * insertar_actividades_administradores(id_usuario INT,id_predio INT,id_actividad INT) - Asignamos el rol de administrador a un usuario sobre una actividad
    * insertar_actividad_horario(id_actividad INT,dia INT,hora_comienzo TIME,hora_finalizacion TIME) - Creacion de un horario para una actividad
    * insertar_actividad_dia_cerrados(id_actividad INT,fecha DATE) Creamos una fecha de dia cerrado
    FUNCIONES
=========================================================================================================

=========================================================================================================
Dar de baja algo:
    * baja_usuario(id_usuario INT) - dar de baja un usuario cliente
    * baja_predio(id_predio INT) - dar de baja un predio
    * baja_actividades(id_actividad INT) - dar de baja una actividad de un predio
    * baja_turno(id_turno INT) - dar de baja un turno, parametro
    Procesos Almacenados
=========================================================================================================

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

Evento para mover tbl_turnos a tbl_turnos_realizados cuando uno finalize
*/

DELIMITER //

CREATE PROCEDURE baja_turno(id_turno INT)
BEGIN
    DELETE FROM tbl_turnos WHERE tbl_turnos.id_turno = id_turno;
END//

CREATE PROCEDURE baja_usuario(id_usuario INT)
BEGIN
    DELETE FROM tbl_turnos WHERE tbl_turnos.id_usuario = id_usuario;
    DELETE FROM tbl_usuarios WHERE tbl_usuarios.id_usuario = id_usuario;
END//

CREATE PROCEDURE baja_actividades (id_actividad INT)
BEGIN
    DELETE FROM tbl_turnos WHERE tbl_turnos.id_actividad = id_actividad;
    DELETE FROM tbl_actividades WHERE tbl_actividades.id_actividad = id_actividad;
END//

CREATE PROCEDURE baja_predio (id_predio INT)
BEGIN
    DELETE FROM tbl_turnos WHERE tbl_turnos.id_predio = id_predio;
    DELETE FROM tbl_actividades WHERE tbl_actividades.id_predio = id_predio;
    DELETE FROM tbl_predios WHERE tbl_predios.id_predio = id_predio;
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

CREATE FUNCTION insertar_usuario (nombre VARCHAR(200), apellido VARCHAR(100), fecha_nacimiento DATE, sexo VARCHAR(1), email VARCHAR(200), password VARCHAR(500))
RETURNS VARCHAR(1000)
BEGIN
    IF ((SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Correo ya en uso","campo":"email"}';
    ELSEIF ((SELECT id_usuario FROM tbl_usuarios_sin_confirmar WHERE tbl_usuarios_sin_confirmar.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Revise su correo","campo":"email"}';

    ELSEIF ((SELECT id_usuario FROM tbl_baja_usuarios WHERE tbl_baja_usuarios.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Diste de baja tu cuenta, revisa tu correo para volverla a activar","campo":"email"}';

    END IF;

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
END//

CREATE FUNCTION activacion_usuario (id_usuario INT)
RETURNS VARCHAR(500)
BEGIN
    IF ((SELECT id_usuario FROM tbl_usuarios WHERE tbl_usuarios.id_usuario = id_usuario LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Tu cuenta ya estaba anteriormente registrada"}';
    END IF;

    IF ((SELECT id_usuario FROM tbl_usuarios_sin_confirmar WHERE tbl_usuarios_sin_confirmar.id_usuario = id_usuario LIMIT 1) IS NULL) THEN
        RETURN '{"mensaje":"Cuenta no encontrada"}';
    END IF;

    INSERT INTO
        tbl_usuarios 
        SELECT 
            id_usuario,nombre,apellido,fecha_nacimiento,sexo,email,password,NULL,NULL,fecha_creacion,now()
        FROM
            tbl_usuarios_sin_confirmar
        WHERE
            tbl_usuarios_sin_confirmar.id_usuario = id_usuario;
    
    DELETE FROM tbl_usuarios_sin_confirmar WHERE tbl_usuarios_sin_confirmar.id_usuario = id_usuario;

    RETURN '1';
END//

CREATE FUNCTION insertar_predio (nombre VARCHAR(400),email VARCHAR(200),password VARCHAR(500),descripcion VARCHAR(10000),localidad VARCHAR(200),direccion VARCHAR(1000))
RETURNS VARCHAR(200)
BEGIN
    IF ((SELECT id_predio FROM tbl_predios WHERE tbl_predios.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Correo ya en uso","campo":"email"}';
    
    ELSEIF ((SELECT id_predio FROM tbl_predios_sin_confirmar WHERE tbl_predios_sin_confirmar.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Revise su correo","campo":"email","enviar-correo":1}';

    ELSEIF ((SELECT id_predio FROM tbl_baja_predios WHERE tbl_baja_predios.email = email LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Diste de baja tu cuenta, revisa tu correo para volverla a activar","campo":"email","enviar-correo":1}';

    END IF;

    INSERT INTO
        tbl_predios_sin_confirmar (nombre,email,password,descripcion,localidad,direccion)
    VALUES
        (
            nombre,
            email,
            password,
            descripcion,
            localidad,
            direccion
        );
        
    RETURN '1';
END//

CREATE FUNCTION activacion_predio (id_predio INT)
RETURNS VARCHAR(500)
BEGIN
    IF ((SELECT id_predio FROM tbl_predios WHERE tbl_predios.id_predio = id_predio LIMIT 1) IS NOT NULL) THEN
        RETURN '{"mensaje":"Tu cuenta ya estaba anteriormente registrada"}';
    END IF;

    IF ((SELECT id_predio FROM tbl_predios_sin_confirmar WHERE tbl_predios_sin_confirmar.id_predio = id_predio LIMIT 1) IS NULL) THEN
        RETURN '{"mensaje":"Cuenta no encontrada"}';
    END IF;

    INSERT INTO
        tbl_predios 
        SELECT 
            id_predio,nombre,email,password,descripcion,localidad,direccion,NULL,0,fecha_creacion,now()
        FROM
            tbl_predios_sin_confirmar
        WHERE
            tbl_predios_sin_confirmar.id_predio = id_predio;
    
    DELETE FROM tbl_predios_sin_confirmar WHERE tbl_predios_sin_confirmar.id_predio = id_predio;

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

CREATE FUNCTION insertar_actividades_administradores(id_usuario INT,id_predio INT,id_actividad INT)
RETURNS VARCHAR(100)
BEGIN
    INSERT INTO
        tbl_actividades_administradores (id_usuario,id_predio,id_actividad)
    VALUES
        (id_usuario,id_predio,id_actividad);
    
    RETURN '1';
END//

CREATE FUNCTION insertar_actividad_horario(id_actividad INT,dia INT,hora_comienzo TIME,hora_finalizacion TIME)
RETURNS VARCHAR(100)
BEGIN
    -- IF (TIMEDIFF(hora_finalizacion,hora_comienzo) <= 0) THEN
    --     RETURN '{"mensaje":"Hora de finalizacion incorrecto"}';
    -- END IF;

    INSERT INTO
        tbl_actividades_horarios_semanales (id_actividad,dia,hora_comienzo,hora_finalizacion)
    VALUES
        (id_actividad,dia,hora_comienzo,hora_finalizacion);

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

CREATE PROCEDURE activacion_usuario_de_baja(id_usuario INT)
BEGIN
    INSERT INTO tbl_usuarios
        SELECT 
            id_usuario,nombre,apellido,fecha_nacimiento,sexo,email,password,null,null,fecha_creacion,fecha_confirmacion
        FROM
            tbl_baja_usuarios
        WHERE 
            tbl_baja_usuarios.id_usuario = id_usuario;
    
    DELETE FROM tbl_baja_usuarios WHERE tbl_baja_usuarios.id_usuario = id_usuario;
END//

CREATE PROCEDURE activacion_predio_de_baja(id_predio INT)
BEGIN
    INSERT INTO tbl_predios
        SELECT 
            id_predio,nombre,email,password,descripcion,localidad,direccion,null,fecha_creacion,fecha_confirmacion
        FROM
            tbl_baja_predios
        WHERE 
            tbl_baja_predios.id_predio = id_predio;
    
    DELETE FROM tbl_baja_predios WHERE tbl_baja_predios.id_predio = id_predio;
END//

CREATE PROCEDURE activacion_actividad_de_baja(id_actividad INT)
BEGIN
    INSERT INTO tbl_actividades
        SELECT 
            id_actividad,id_predio,nombre_actividad,telefono,usuarios_maximos_x_turno,descripcion,vistas,null,fecha_creacion
        FROM
            tbl_baja_actividades
        WHERE 
            tbl_baja_actividades.id_actividad = id_actividad;
    
    DELETE FROM tbl_baja_actividades WHERE tbl_baja_actividades.id_actividad = id_actividad;
END//

DELIMITER ;