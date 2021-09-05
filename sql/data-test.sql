INSERT INTO
    tbl_usuarios (
        id_usuario,
        nombre,
        apellido,
        fecha_nacimiento,
        sexo,
        email,
        password
    )
VALUES
    (
        1,
        'Tiago',
        'Pujia',
        '2004-02-13',
        'h',
        'tiagonahuelpujia@gmail.com',
        'contraseña'
    ),
    (
        2,
        'Pato',
        'Pujia',
        '1980-02-15',
        'h',
        'patricio_pujia@yahoo.com',
        'contraseña'
    );

UPDATE tbl_usuarios SET nombre = 'Nahuel', fecha_ultimo_ingreso = NOW() WHERE id_usuario = 1;

INSERT INTO
    tbl_predios (
        nombre,
        email,
        password,
        descripcion,
        localidad,
        direccion
    )
VALUES
    (
        'Philidor',
        'correo@asd',
        '1234',
        'club de ajedrez',
        'moron',
        'asd'
    );

INSERT INTO
    tbl_actividades (
        id_predio,
        nombre_actividad,
        usuarios_maximos_x_turno
    )
VALUES
    (
        1,
        'Ajedrez',
        5
    );

INSERT INTO
    tbl_actividades_horarios_semanales (
        id_actividad,
        dia,
        hora_comienzo,
        hora_finalizacion
    )
VALUES
    (
        1,
        6,
        '11:30:00',
        '15:30:00'
    ),
    (
        1,
        2,
        '14:00:00',
        '18:30:00'
    ),
    (
        1,
        4,
        '14:00:00',
        '18:30:00'
    );

INSERT INTO
    tbl_turnos (id_usuario, id_predio, id_actividad, id_horario)
VALUES
    (1, 1, 1, 1),
    (1, 1, 1, 2),
    (2, 1, 1, 1);