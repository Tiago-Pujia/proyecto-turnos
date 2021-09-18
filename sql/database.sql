DROP DATABASE IF EXISTS db_turnos;
CREATE DATABASE IF NOT EXISTS db_turnos CHARACTER SET utf8 COLLATE utf8_general_ci;
USE db_turnos;

DROP USER IF EXISTS 'USER_DML'@'localhost';
CREATE USER IF NOT EXISTS 'USER_DML'@'localhost' IDENTIFIED BY 'rivadavia';

GRANT 
    SELECT , INSERT , UPDATE, DELETE ,EXECUTE 
ON db_turnos.* TO 'USER_DML' @'localhost';

FLUSH PRIVILEGES;

-- =========================================================================================================
-- TABLAS APARTES
-- =========================================================================================================

CREATE TABLE tbl_nombres_dias (
    id_dia INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    dia CHAR(20) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE tbl_general (
    agrupador VARCHAR(500) NOT NULL,
    descripcion VARCHAR(500),
    valor VARCHAR(500) NOT NULL
) ENGINE = MyISAM;

CREATE TABLE tbl_sugerencias (
    id_usuario INT UNSIGNED,
    mensaje VARCHAR(10000),
    fecha_creacion DATETIME DEFAULT now()
) ENGINE = InnoDB;

CREATE TABLE tbl_logs (
    tabla VARCHAR(100) NOT NULL,
    campo_modificado VARCHAR(100) NOT NULL,
    id INT UNSIGNED NOT NULL,
    valor_nuevo VARCHAR(10000) NOT NULL,
    valor_viejo VARCHAR(10000),
    fecha_cambio DATETIME NOT NULL DEFAULT NOW()
) ENGINE = MyISAM;


-- =========================================================================================================
-- TABLAS ROLES
-- =========================================================================================================

CREATE TABLE tbl_roles(
    id_rol INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(100)
) ENGINE = InnoDB;

CREATE TABLE tbl_permisos (
    id_permiso INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    permiso VARCHAR(1000) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE tbl_permisos_x_roles(
    id_rol INT UNSIGNED NOT NULL,
    id_permiso INT UNSIGNED NOT NULL,

    FOREIGN KEY (id_rol) REFERENCES tbl_roles(id_rol),
    FOREIGN KEY (id_permiso) REFERENCES tbl_permisos(id_permiso)
) ENGINE = InnoDB;


-- =========================================================================================================
-- TABLAS PRINCIPALES
-- =========================================================================================================

CREATE TABLE tbl_usuarios(
    id_usuario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    sexo BIT,
    email VARCHAR(200) UNIQUE NOT NULL,
    password VARCHAR(500) NOT NULL,
    foto_perfil MEDIUMBLOB,
    id_rol INT UNSIGNED DEFAULT 1,
    fecha_ultimo_ingreso DATETIME,
    fecha_creacion DATETIME DEFAULT NOW(),
    fecha_confirmacion DATETIME,
    fecha_baja DATETIME,

    FOREIGN KEY (id_rol) REFERENCES tbl_roles(id_rol) ON DELETE CASCADE
) ENGINE = InnoDB;


CREATE TABLE tbl_predios(
    id_predio INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_propietario INT UNSIGNED NOT NULL,
    nombre VARCHAR(400) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    telefono VARCHAR(100),
    descripcion VARCHAR(10000),
    provincia VARCHAR(200) NOT NULL,
    localidad VARCHAR(200) NOT NULL,
    direccion VARCHAR(1000) NOT NULL,
    foto_logo MEDIUMBLOB,
    vistas INT DEFAULT 0,
    fecha_baja DATETIME,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_propietario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades(
    id_actividad INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_predio INT UNSIGNED NOT NULL,
    nombre_actividad VARCHAR(200) NOT NULL,
    telefono VARCHAR(100),
    usuarios_maximos_x_turno SMALLINT UNSIGNED NOT NULL,
    descripcion VARCHAR(10000),
    foto_actividad MEDIUMBLOB,
    vistas INT DEFAULT 0,
    fecha_baja DATETIME,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_horarios_semanales(
    id_horario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_actividad INT UNSIGNED NOT NULL,
    dia INT UNSIGNED NOT NULL,
    precio INT UNSIGNED,
    hora_comienzo TIME NOT NULL,
    hora_finalizacion TIME,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (dia) REFERENCES tbl_nombres_dias(id_dia) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_dias_cerrados_temporalmente(
    id_dia INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_actividad INT UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_administradores(
    id_administrador INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED COMMENT 'Si no se especifica las actividades, tiene acceso a todos aquellas',
    fecha_baja DATETIME,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_turnos(
    id_turno INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED NOT NULL,
    id_horario INT UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    fecha_baja DATETIME,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_horario) REFERENCES tbl_actividades_horarios_semanales(id_horario) ON DELETE CASCADE
) ENGINE = InnoDB;


-- =========================================================================================================
-- TABLAS SECUNDARIAS
-- =========================================================================================================

CREATE TABLE tbl_actividades_anuncios(
    id_actividad INT UNSIGNED NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion VARCHAR(10000),
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_predios_anuncios(
    id_predio INT UNSIGNED NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion VARCHAR(10000),
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_comentarios (
    id_actividad INT UNSIGNED NOT NULL,
    id_usuario INT UNSIGNED,
    anonimo BIT,
    calificacion ENUM("1","2","3","4","5"),
    comentario VARCHAR(10000) NOT NULL,

    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_predio_comentarios (
    id_predio INT UNSIGNED NOT NULL,
    id_usuario INT UNSIGNED,
    anonimo BIT,
    calificacion ENUM("1","2","3","4","5"),
    comentario VARCHAR(10000) NOT NULL,

    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_predios_favoritos_usuarios(
    id_usuario INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME DEFAULT NOW(),

    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario),
    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio)
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_favoritos_usuarios(
    id_usuario INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME DEFAULT NOW(),

    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario),
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad)
) ENGINE = InnoDB;


-- =========================================================================================================
-- VISTAS
-- =========================================================================================================

CREATE VIEW vw_tbl_usuarios_activos AS
SELECT * FROM tbl_usuarios WHERE fecha_baja IS NULL AND fecha_confirmacion IS NOT NULL;

CREATE VIEW vw_tbl_predios_activos AS
SELECT * FROM tbl_predios WHERE fecha_baja IS NULL;

CREATE VIEW vw_tbl_actividades_activos AS
SELECT * FROM tbl_actividades WHERE fecha_baja IS NULL;

CREATE VIEW vw_tbl_turnos_activos AS
SELECT * FROM tbl_turnos WHERE fecha_baja IS NULL;

CREATE VIEW vw_tbl_administradores_activos AS
SELECT * FROM tbl_administradores WHERE fecha_baja IS NULL;

-- =========================================================================================================
-- DATOS DDL
-- =========================================================================================================

INSERT INTO
    tbl_nombres_dias (dia)
VALUES
    ('Monday'),
    ('Tuesday'),
    ('Wednesday'),
    ('Thursday'),
    ('Friday'),
    ('Saturday'),
    ('Sunday');

INSERT INTO
    tbl_general
VALUES
    ('sexo','Masculino',0),
    ('sexo','Femenino',1);

INSERT INTO 
    tbl_roles (descripcion) 
VALUES
    ('Administrador'),
    ('Cliente'),
    ('Super-Administrador');

INSERT INTO 
    tbl_permisos (permiso)
VALUES
    ('Consulta de Turnos'),
    ('Consulta Ampliada de Turnos'),
    ('Reserva de Turno Propios'),
    ('Alta de Abonos'),
    ('Transalado de Abonos'),
    ('Baja de Usuarios'),
    ('Alta de usuarios'),
    ('Modificacion de Usuarios'),
    ('ABM de Predios'),
    ('ABM de Actividades'),
    ('Alta de turnos'),
    ('Reserva de turnos Ampliados'),
    ('Consulta de Logs'),
    ('Cancelacion de Turnos Ampliados'),
    ('Cancelacion de Turnos Propios'),
    ('Administrar Permiso por Rol'),
    ('Administrar Roles'),
    ('Modificacion de Datos Usuario Propios'),
    ('Modificacion de Datos Usuarios Ampliados');

INSERT INTO 
    tbl_permisos_x_roles
VALUES
    (1,2),
    (1,4),
    (1,5),
    (1,6),
    (1,7),
    (1,8),
    (1,9),
    (1,10),
    (1,11),
    (1,12),
    (1,14),

    (3,2),
    (3,3),
    (3,4),
    (3,5),
    (3,6),
    (3,7),
    (3,8),
    (3,9),
    (3,10),
    (3,11),
    (3,12),
    (3,14),
    (3,16),
    (3,17),

    (2,1),
    (2,3),
    (2,15);