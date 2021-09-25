DELIMITER // 

CREATE TRIGGER after_cambios_usuarios 
AFTER
UPDATE
ON tbl_usuarios 
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_usuarios';
    DECLARE id_registro INT UNSIGNED;

    SET id_registro = (OLD.id_usuario);

    IF (NEW.nombre != OLD.nombre) THEN
        CALL insert_log(tabla,'nombre',id_registro,NEW.nombre,OLD.nombre);
    END IF;

    IF (NEW.apellido != OLD.apellido) THEN
        CALL insert_log(tabla,'apellido',id_registro,NEW.apellido,OLD.apellido);
    END IF;

    IF (NEW.fecha_nacimiento != OLD.fecha_nacimiento) THEN
        CALL insert_log(tabla,'fecha_nacimiento',id_registro,NEW.fecha_nacimiento,OLD.fecha_nacimiento);
    END IF;

    IF (NEW.sexo != OLD.sexo) THEN
        CALL insert_log(tabla,'sexo',id_registro,NEW.sexo,OLD.sexo);
    END IF;

    IF (NEW.email != OLD.email) THEN
        CALL insert_log(tabla,'email',id_registro,NEW.email,OLD.email);
    END IF;

    IF (NEW.password != OLD.password) THEN
        CALL insert_log(tabla,'password',id_registro,NEW.password,OLD.password);
    END IF;

    IF (NEW.id_rol != OLD.id_rol) THEN
        CALL insert_log(tabla,'id_rol',id_registro,NEW.id_rol,OLD.id_rol);
    END IF;

    IF (NEW.fecha_confirmacion != OLD.fecha_confirmacion) THEN
        CALL insert_log(tabla,'fecha_confirmacion',id_registro,NEW.fecha_confirmacion,OLD.fecha_confirmacion);
    END IF;
    IF (NEW.fecha_baja != OLD.fecha_baja) THEN
        CALL insert_log(tabla,'fecha_baja',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;
END//

CREATE TRIGGER after_cambios_predios
AFTER
UPDATE
ON tbl_predios
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_predios';
    DECLARE id_registro INT UNSIGNED;
    SET id_registro = (OLD.id_predio);

    IF (NEW.nombre != OLD.nombre) THEN
        CALL insert_log(tabla,'nombre',id_registro,NEW.nombre,OLD.nombre);
    END IF;
    IF (NEW.email != OLD.email) THEN
        CALL insert_log(tabla,'email',id_registro,NEW.email,OLD.email);
    END IF;
    IF (NEW.telefono != OLD.telefono) THEN
        CALL insert_log(tabla,'telefono',id_registro,NEW.telefono,OLD.telefono);
    END IF;
    IF (NEW.descripcion != OLD.descripcion) THEN
        CALL insert_log(tabla,'descripcion',id_registro,NEW.descripcion,OLD.descripcion);
    END IF;
    IF (NEW.provincia != OLD.provincia) THEN
        CALL insert_log(tabla,'provincia',id_registro,NEW.provincia,OLD.provincia);
    END IF;
    IF (NEW.localidad != OLD.localidad) THEN
        CALL insert_log(tabla,'localidad',id_registro,NEW.localidad,OLD.localidad);
    END IF;
    IF (NEW.direccion != OLD.direccion) THEN
        CALL insert_log(tabla,'direccion',id_registro,NEW.direccion,OLD.direccion);
    END IF;
    IF (NEW.fecha_baja != OLD.fecha_baja) THEN
        CALL insert_log(tabla,'fecha_baja',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;
END//

CREATE TRIGGER after_cambios_predios_propietarios
AFTER
UPDATE
on tbl_predios_propietarios
FOR EACH ROW
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_predios_propietarios';
    DECLARE id_registro INT UNSIGNED;
    SET id_registro = (OLD.id_propietario);

    IF (NEW.fecha_baja != OLD.fecha_baja) THEN
        CALL insert_log(tabla,'fecha_baja',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;
END//

CREATE TRIGGER after_cambios_actividades
AFTER
UPDATE
ON tbl_actividades
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_actividades';
    DECLARE id_registro INT UNSIGNED;

    SET id_registro = (OLD.id_actividad);

    IF (NEW.nombre_actividad != OLD.nombre_actividad) THEN
        CALL insert_log(tabla,'nombre_actividad',id_registro,NEW.nombre_actividad,OLD.nombre_actividad);
    END IF;
    IF (NEW.telefono != OLD.telefono) THEN
        CALL insert_log(tabla,'telefono',id_registro,NEW.telefono,OLD.telefono);
    END IF;
    IF (NEW.usuarios_maximos_x_turno != OLD.usuarios_maximos_x_turno) THEN
        CALL insert_log(tabla,'usuarios_maximos_x_turno',id_registro,NEW.usuarios_maximos_x_turno,OLD.usuarios_maximos_x_turno);
    END IF;
    IF (NEW.descripcion != OLD.descripcion) THEN
        CALL insert_log(tabla,'descripcion',id_registro,NEW.descripcion,OLD.descripcion);
    END IF;
    IF (NEW.fecha_baja != OLD.fecha_baja) THEN
        CALL insert_log(tabla,'fecha_baja',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;
END//

CREATE TRIGGER after_cambios_actividades_horarios_semanales 
AFTER
UPDATE
ON tbl_actividades_horarios_semanales
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_actividades_horarios_semanales';
    DECLARE id_registro INT UNSIGNED;

    SET id_registro = (OLD.id_horario);

    IF (NEW.dia != OLD.dia) THEN
        CALL insert_log(tabla,'dia',id_registro,NEW.dia,OLD.dia);
    END IF;
    IF (NEW.precio != OLD.precio) THEN
        CALL insert_log(tabla,'precio',id_registro,NEW.precio,OLD.precio);
    END IF;
    IF (NEW.hora_comienzo != OLD.hora_comienzo) THEN
        CALL insert_log(tabla,'hora_comienzo',id_registro,NEW.hora_comienzo,OLD.hora_comienzo);
    END IF;
    IF (NEW.hora_finalizacion != OLD.hora_finalizacion) THEN
        CALL insert_log(tabla,'hora_finalizacion',id_registro,NEW.hora_finalizacion,OLD.hora_finalizacion);
    END IF;
END//

CREATE TRIGGER after_cambios_administradores_x_predio
AFTER
UPDATE
ON tbl_administradores_x_predio 
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_administradores_x_predio';
    DECLARE id_registro INT UNSIGNED;

    SET id_registro = (OLD.id_administrador);

    IF (NEW.acceso_global_actividades != OLD.acceso_global_actividades) THEN
        CALL insert_log(tabla,'acceso_global_actividades',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;

    IF (NEW.fecha_baja != OLD.fecha_baja) THEN
        CALL insert_log(tabla,'fecha_baja',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;
END//

CREATE TRIGGER after_cambios_administradores_x_actividad
AFTER
UPDATE
ON tbl_administradores_x_actividad 
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_administradores_x_actividad';
    DECLARE id_registro INT UNSIGNED;

    SET id_registro = (OLD.id_administrador);

    IF (NEW.fecha_baja != OLD.fecha_baja) THEN
        CALL insert_log(tabla,'fecha_baja',id_registro,NEW.fecha_baja,OLD.fecha_baja);
    END IF;
END//

/*
Plantilla:
CREATE TRIGGER after_cambios_ -- Especificar 
AFTER
UPDATE
ON -- Especificar 
FOR EACH ROW 
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_usuarios';
    DECLARE id_registro INT UNSIGNED;

    SET id_registro = (OLD.id_registro);

    IF (NEW.nombre != OLD.nombre) THEN
        CALL insert_log(tabla,'nombre',id_registro,NEW.nombre,OLD.nombre);
    END IF;

END//
*/

*/
/*
Idea que deberia de completarse:

CREATE TRIGGER after_cambios_usuarios
AFTER
UPDATE
ON tbl_usuarios
FOR EACH ROW
BEGIN
    DECLARE tabla VARCHAR(100) DEFAULT 'tbl_usuarios';
    DECLARE campo_id VARCHAR(100);
    DECLARE campo_tabla VARCHAR(100);
    DECLARE cursor_listo BIT DEFAULT 0;
    DECLARE cursor_1 CURSOR FOR
        SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'db_turnos' AND TABLE_NAME = tabla;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cursor_listo = 1;

    SET campo_id = (SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'db_turnos' AND TABLE_NAME = tabla AND COLUMN_KEY = 'PRI');

    OPEN cursor_1;
        ciclo_1: LOOP
            FETCH cursor_1 INTO campo_tabla;
            IF (cursor_listo = 1) THEN 
                LEAVE ciclo_1;
            END IF;

            SET @new_campo = NEW.campo_tabla,
                @old_campo = OLD.campo_tabla,
                @id = OLD.campo_id;

            IF (@new_campo != @old_campo) THEN
                INSERT INTO
                    tbl_logs (tabla, campo_modificado, id, valor_nuevo, valor_viejo) 
                VALUES 
                    (
                        tabla,
                        campo_tabla,
                        @id,
                        @new_campo,
                        @old_campo
                    );
            END IF;
        END LOOP ciclo_1;
    CLOSE cursor_1;
END//
*/
DELIMITER ;