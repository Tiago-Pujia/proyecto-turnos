CREATE TABLE tbl_historial_usuarios (
    id_usuario INT UNSIGNED NOT NULL,
    nombre VARCHAR(200),
    apellido VARCHAR(100),
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M'),
    email VARCHAR(200),
    password VARCHAR(500),
    email_confirmado BIT DEFAULT 0,
    fecha_creacion DATETIME,
    fecha_cambio DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_historial_predios (
    id_predio INT UNSIGNED NOT NULL,
    nombre VARCHAR(200),
    email VARCHAR(200),
    password VARCHAR(500),
    descripcion VARCHAR(2000),
    localidad VARCHAR(200),
    direccion VARCHAR(1000),
    email_confirmado BIT,
    fecha_creacion DATETIME,
    fecha_cambio DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_historial_actividades (
    id_actividad INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED,
    nombre_actividad VARCHAR(200),
    usuarios_maximos_x_turno SMALLINT UNSIGNED,
    precio INT UNSIGNED,
    descripcion VARCHAR(2000),
    fecha_creacion DATETIME,
    fecha_cambio DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_historial_actividades_horarios (
    id_horario INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED,
    dias INT UNSIGNED,
    hora_comienzo TIME,
    hora_finalizacion TIME,
    fecha_creacion DATETIME,
    fecha_cambio DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_historial_predio_dias_cerrados_temporalmente (
    id_actividad INT UNSIGNED NOT NULL,
    dia DATE,
    fecha_creacion DATETIME,
    fecha_cambio DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

DELIMITER // 

CREATE TRIGGER after_cambios_usuarios 
AFTER
UPDATE
ON tbl_usuarios 
FOR EACH ROW 
BEGIN
    set
        @nombre = NULL,
        @apellido = NULL,
        @fecha_nacimiento = NULL,
        @sexo = NULL,
        @email = NULL,
        @password = NULL,
        @fecha_creacion = NULL;

    IF (NEW.nombre != OLD.nombre) THEN
        SET @nombre = NEW.nombre;
    END IF;

    IF (NEW.apellido != OLD.apellido) THEN
        SET @apellido = NEW.apellido;
    END IF;

    IF (NEW.fecha_nacimiento != OLD.fecha_nacimiento) THEN
        SET @fecha_nacimiento = NEW.fecha_nacimiento;
    END IF;

    IF (NEW.sexo != OLD.sexo) THEN
        SET @sexo = NEW.sexo;
    END IF;

    IF (NEW.email != OLD.email) THEN
        SET @email = NEW.email;
    END IF;

    IF (NEW.password != OLD.password) THEN
        SET @password = NEW.password;
    END IF;

    IF (NEW.fecha_creacion != OLD.fecha_creacion) THEN
        SET @fecha_creacion = NEW.fecha_creacion;
    END IF;

    INSERT INTO
        tbl_historial_usuarios (
            id_usuario,
            nombre,
            apellido,
            fecha_nacimiento,
            email,
            password,
            fecha_creacion
        )
    VALUES
        (
            OLD.id_usuario,
            @nombre,
            @apellido,
            @fecha_nacimiento,
            @email,
            @password,
            @fecha_creacion
        );
END// 

CREATE TRIGGER after_cambios_predios
AFTER
UPDATE
ON tbl_predios 
FOR EACH ROW 
BEGIN
    set
        @nombre = NULL,
        @email = NULL,
        @password = NULL,
        @descripcion = NULL,
        @localidad = NULL,
        @direccion = NULL,
        @email_confirmado = NULL,
        @fecha_creacion = NULL;

    IF (NEW.nombre != OLD.nombre) THEN
        SET @nombre = NEW.nombre;
    END IF;

    IF (NEW.email != OLD.email) THEN
        SET @email = NEW.email;
    END IF;

    IF (NEW.descripcion != OLD.descripcion) THEN
        SET @descripcion = NEW.descripcion;
    END IF;

    IF (NEW.localidad != OLD.localidad) THEN
        SET @password = NEW.localidad;
    END IF;

    IF (NEW.direccion != OLD.direccion) THEN
        SET @password = NEW.direccion;
    END IF;

    IF (NEW.email_confirmado != OLD.email_confirmado) THEN
        SET @email_confirmado = NEW.email_confirmado;
    END IF;

    IF (NEW.fecha_creacion != OLD.fecha_creacion) THEN
        SET @fecha_creacion = NEW.fecha_creacion;
    END IF;

    INSERT INTO
        tbl_historial_predios (
            id_predio,
            nombre,
            email,
            password,
            descripcion,
            localidad,
            direccion,
            email_confirmado,
            fecha_creacion
        )
    VALUES
        (
            OLD.id_predio,
            @nombre,
            @email,
            @password,
            @descripcion,
            @localidad,
            @direccion,
            @email_confirmado,
            @fecha_creacion
        );
END// 

CREATE TRIGGER after_cambios_actividades
AFTER
UPDATE
ON tbl_actividades 
FOR EACH ROW 
BEGIN
    set
        @id_predio = NULL,
        @nombre_actividad = NULL,
        @telefono = NULL,
        @usuarios_maximos_x_turno = NULL,
        -- @precio = NULL,
        @descripcion = NULL,
        @fecha_creacion = NULL;

    IF (NEW.id_predio != OLD.id_predio) THEN
        SET @id_predio = NEW.id_predio;
    END IF;

    IF (NEW.nombre_actividad != OLD.nombre_actividad) THEN
        SET @nombre_actividad = NEW.nombre_actividad;
    END IF;

    IF (NEW.telefono != OLD.telefono) THEN
        SET @telefono = NEW.telefono;
    END IF;

    IF (NEW.usuarios_maximos_x_turno != OLD.usuarios_maximos_x_turno) THEN
        SET @usuarios_maximos_x_turno = NEW.usuarios_maximos_x_turno;
    END IF;

    -- IF (NEW.precio != OLD.precio) THEN
    --     SET @precio = NEW.precio;
    -- END IF;

    IF (NEW.descripcion != OLD.descripcion) THEN
        SET @descripcion = NEW.descripcion;
    END IF;

    IF (NEW.fecha_creacion != OLD.fecha_creacion) THEN
        SET @fecha_creacion = NEW.fecha_creacion;
    END IF;

    INSERT INTO
        tbl_historial_actividades (
            id_predio,
            nombre_actividad,
            telefono,
            usuarios_maximos_x_turno,
            precio,
            descripcion,
            fecha_creacion
        )
    VALUES
        (
            OLD.id_actividad,
            @id_predio,
            @nombre_actividad,
            @telefono,
            @usuarios_maximos_x_turno,
            @precio,
            @descripcion,
            @fecha_creacion
        );
END// 

CREATE TRIGGER after_cambios_horarios_actividades
AFTER
UPDATE
ON tbl_actividades_horarios_semanales 
FOR EACH ROW 
BEGIN
    set
        @id_actividad = NULL,
        @dia = NULL,
        @hora_comienzo = NULL,
        @hora_finalizacion = NULL,
        @fecha_creacion = NULL;

    IF (NEW.id_actividad != OLD.id_actividad) THEN
        SET @id_actividad = NEW.id_actividad;
    END IF;

    IF (NEW.dia != OLD.dia) THEN
        SET @dia = NEW.dia;
    END IF;

    IF (NEW.hora_comienzo != OLD.hora_comienzo) THEN
        SET @hora_comienzo = NEW.hora_comienzo;
    END IF;

    IF (NEW.hora_finalizacion != OLD.hora_finalizacion) THEN
        SET @hora_finalizacion = NEW.hora_finalizacion;
    END IF;

    IF (NEW.fecha_creacion != OLD.fecha_creacion) THEN
        SET @fecha_creacion = NEW.fecha_creacion;
    END IF;

    INSERT INTO
        tbl_historial_actividades_horarios (
            id_actividad,
            dia,
            hora_comienzo,
            hora_finalizacion,
            fecha_creacion
        )
    VALUES
        (
            OLD.id_horario,
            @id_actividad,
            @dia,
            @hora_comienzo,
            @hora_finalizacion,
            @fecha_creacion
        );
END// 

CREATE TRIGGER after_cambios_predio_dias_cerrados_temporalmente
AFTER
UPDATE
ON tbl_historial_predio_dias_cerrados_temporalmente 
FOR EACH ROW 
BEGIN
    SET
        @dia = NULL,
        @fecha_creacion = NULL;

    IF (NEW.dia != OLD.dia) THEN
        SET @dia = NEW.dia;
    END IF;

    IF (NEW.fecha_creacion != OLD.fecha_creacion) THEN
        SET @fecha_creacion = NEW.fecha_creacion;
    END IF;

    INSERT INTO
        tbl_historial_actividades_horarios (
            id_actividad,
            dia,
            fecha_creacion
        )
    VALUES
        (
            OLD.id_actividad,
            @dia,
            @fecha_creacion
        );
END// 

DELIMITER ;