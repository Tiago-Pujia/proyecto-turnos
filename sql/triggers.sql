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
        @password = NULL;

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

    INSERT INTO
        tbl_historial_usuarios (
            id_usuario,
            nombre,
            apellido,
            fecha_nacimiento,
            email,
            password
        )
    VALUES
        (
            OLD.id_usuario,
            @nombre,
            @apellido,
            @fecha_nacimiento,
            @email,
            @password
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
        @direccion = NULL;

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

    INSERT INTO
        tbl_historial_predios (
            id_predio,
            nombre,
            email,
            password,
            descripcion,
            localidad,
            direccion
        )
    VALUES
        (
            OLD.id_predio,
            @nombre,
            @email,
            @password,
            @descripcion,
            @localidad,
            @direccion
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
        @descripcion = NULL;

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

    INSERT INTO
        tbl_historial_actividades (
            id_predio,
            nombre_actividad,
            telefono,
            usuarios_maximos_x_turno,
            precio,
            descripcion
        )
    VALUES
        (
            OLD.id_actividad,
            @id_predio,
            @nombre_actividad,
            @telefono,
            @usuarios_maximos_x_turno,
            @precio,
            @descripcion
        );
END// 

CREATE TRIGGER after_delete_turnos
AFTER
DELETE
ON tbl_turnos
FOR EACH ROW
BEGIN
    INSERT INTO 
        tbl_baja_turnos
    VALUES
        (
            old.id_turno,
            old.id_usuario,
            old.id_predio,
            old.id_actividad,
            old.id_horario,
            old.fecha,
            old.fecha_creacion,
            now()
        );
END//

CREATE TRIGGER after_delete_usuarios
AFTER
DELETE
ON tbl_usuarios
FOR EACH ROW
BEGIN
    INSERT INTO 
        tbl_baja_usuarios
    VALUES
        (
            old.id_usuario,
            old.nombre,
            old.apellido,
            old.fecha_nacimiento,
            old.sexo,
            old.email,
            old.password,
            old.fecha_creacion,
            old.fecha_confirmacion,
            now()
        );
END//

CREATE TRIGGER after_delete_actividades
AFTER
DELETE
ON tbl_actividades
FOR EACH ROW
BEGIN
    INSERT INTO
        tbl_baja_actividades
    VALUES
        (
            OLD.id_actividad,
            OLD.id_predio,
            OLD.nombre_actividad,
            OLD.telefono,
            OLD.usuarios_maximos_x_turno,
            OLD.descripcion,
            OLD.vistas,
            OLD.fecha_creacion,
            now()
        );
END//

CREATE TRIGGER after_delete_predio
AFTER
DELETE
ON tbl_predios
FOR EACH ROW
BEGIN
    INSERT INTO
        tbl_baja_predios
    VALUES
        (
            OLD.id_predio,
            OLD.nombre,
            OLD.email,
            OLD.password,
            OLD.descripcion,
            OLD.localidad,
            OLD.direccion,
            OLD.fecha_creacion,
            OLD.fecha_confirmacion,
            now()
        );
END//
DELIMITER ;