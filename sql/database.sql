DROP DATABASE IF EXISTS db_turnos;
CREATE DATABASE IF NOT EXISTS db_turnos CHARACTER SET utf8 COLLATE utf8_general_ci;
USE db_turnos;

DROP USER IF EXISTS 'USER_DML'@'localhost';
CREATE USER IF NOT EXISTS 'USER_DML'@'localhost' IDENTIFIED BY 'rivadavia';

GRANT 
    SELECT , INSERT , UPDATE, EXECUTE 
ON db_turnos.* TO 'USER_DML' @'localhost';

FLUSH PRIVILEGES;

CREATE TABLE tbl_usuarios_sin_confirmar (
    id_usuario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M'),
    email VARCHAR(200) UNIQUE NOT NULL,
    password VARCHAR(500) NOT NULL,
    fecha_creacion DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_usuarios(
    id_usuario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M'),
    email VARCHAR(200) UNIQUE NOT NULL,
    password VARCHAR(500) NOT NULL,
    foto_perfil MEDIUMBLOB,
    fecha_ultimo_ingreso DATETIME,
    fecha_creacion DATETIME,
    fecha_alta DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_predios(
    id_predio INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(400) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    password VARCHAR(500) NOT NULL,
    descripcion VARCHAR(2000),
    localidad VARCHAR(200) NOT NULL,
    direccion VARCHAR(1000) NOT NULL,
    foto_logo MEDIUMBLOB,
    vistas INT DEFAULT 0,
    email_confirmado BIT DEFAULT 0,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_predios_anuncios(
    id_anuncio INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_predio INT UNSIGNED NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(10000),
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio)
) ENGINE = InnoDB;


CREATE TABLE tbl_predio_comentarios (
    id_comentario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_predio INT UNSIGNED NOT NULL,
    id_usuario INT UNSIGNED,
    anonimo BIT,
    calificacion ENUM("1","2","3","4","5"),
    comentario VARCHAR(10000) NOT NULL,

    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades(
    id_actividad INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_predio INT UNSIGNED NOT NULL,
    nombre_actividad VARCHAR(200) NOT NULL,
    telefono VARCHAR(100),
    usuarios_maximos_x_turno SMALLINT UNSIGNED NOT NULL,
    -- precio INT UNSIGNED,
    descripcion VARCHAR(2000),
    vistas INT DEFAULT 0,
    foto_actividad MEDIUMBLOB,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_administradores(
    id_usuario INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_anuncios(
    id_anuncio INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_actividad INT UNSIGNED NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(10000),
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad)
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_comentarios (
    id_comentario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_actividad INT UNSIGNED NOT NULL,
    id_usuario INT UNSIGNED,
    anonimo BIT,
    calificacion ENUM("1","2","3","4","5"),
    comentario VARCHAR(10000) NOT NULL,

    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_nombres_dias(
    id_dia INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    dia CHAR(20) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_horarios_semanales(
    id_horario INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_actividad INT UNSIGNED NOT NULL,
    dia INT UNSIGNED NOT NULL,
    hora_comienzo TIME NOT NULL,
    hora_finalizacion TIME,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (dia) REFERENCES tbl_nombres_dias(id_dia) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_actividades_dias_cerrados_temporalmente(
    id_actividad INT UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_actividad) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE tbl_turnos(
    id_turno INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED NOT NULL,
    id_horario INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_usuario) REFERENCES tbl_usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_predio) REFERENCES tbl_predios(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES tbl_actividades(id_predio) ON DELETE CASCADE,
    FOREIGN KEY (id_horario) REFERENCES tbl_actividades_horarios_semanales(id_horario) ON DELETE CASCADE
) ENGINE = InnoDB;

-- CREATE TABLE tbl_general (
--     agrupador VARCHAR(500) NOT NULL,
--     descripcion VARCHAR(500) NOT NULL,
--     valor VARCHAR(500) NOT NULL
-- ) ENGINE = InnoDB;

INSERT INTO
    tbl_nombres_dias (dia)
VALUES
    ('lunes'),
    ('martes'),
    ('miercoles'),
    ('jueves'),
    ('viernes'),
    ('sabado'),
    ('domingo');


CREATE TABLE tbl_baja_usuarios(
    id_usuario INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M'),
    email VARCHAR(200) NOT NULL,
    password VARCHAR(500) NOT NULL,
    email_confirmado BIT,
    fecha_creacion DATETIME,
    fecha_baja DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_baja_predios(
    id_predio INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(400) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    password VARCHAR(500) NOT NULL,
    descripcion VARCHAR(2000),
    localidad VARCHAR(200) NOT NULL,
    direccion VARCHAR(1000) NOT NULL,
    email_confirmado BIT DEFAULT 0,
    fecha_creacion DATETIME,
    fecha_baja DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_baja_actividades(
    id_actividad INT UNSIGNED PRIMARY KEY,
    id_predio INT UNSIGNED NOT NULL,
    nombre_actividad VARCHAR(200) NOT NULL,
    telefono VARCHAR(100),
    usuarios_maximos_x_turno SMALLINT UNSIGNED NOT NULL,
    -- precio INT UNSIGNED,
    descripcion VARCHAR(2000),
    fecha_creacion DATETIME,
    fecha_baja DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_baja_turnos (
    id_turno INT UNSIGNED PRIMARY KEY,
    id_usuario INT UNSIGNED NOT NULL,
    id_predio INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED NOT NULL,
    id_horario INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME,
    fecha_baja DATETIME DEFAULT NOW()
) ENGINE = InnoDB;

CREATE TABLE tbl_sugerencias (
    id_usuario INT UNSIGNED,
    mensaje VARCHAR(10000),
    fecha_creacion DATETIME DEFAULT now()
) ENGINE = InnoDB;