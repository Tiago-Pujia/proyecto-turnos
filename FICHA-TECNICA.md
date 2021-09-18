# Base de Datos

Se esta utilizando el DBMS MySQL.
El unico orden de la ejecucion de archivos SQL es primero "database.sql" y el resto no necesita un orden.
El archivo "functions-procedures.sql" contiene al inicio un indice de los actos que pueden hacerse en la BD.

## Funciones y Procesos Almacenados Disponibles para Interactuar con la BD

> **Inserción de datos primarios:** 
>
> *Funciones*
> 
>> ***insertar_usuario(nombre VARCHAR(200), apellido VARCHAR(100), fecha_nacimiento DATE, sexo BIT, email VARCHAR(200), password VARCHAR(500))***
>>
>> Insertamos un usuario 
>
>> ***insertar_predio(id_propietario INT,nombre VARCHAR(400),email VARCHAR(200), telefono VARCHAR(100),descripcion VARCHAR(2000),provincia VARCHAR(200), localidad VARCHAR(200),direccion VARCHAR(1000))***
>> 
>> Insertamos un predio
> 
>> ***insertar_actividad(id_predio INT,nombre_actividad VARCHAR(400),telefono VARCHAR(100),usuarios_maximos_x_turno SMALLINT DEFAULT 0,descripcion VARCHAR(10000),foto_actividad MEDIUMBLOB)***
>>
>> Insertamos una actividad
>
>> ***insertar_turno(id_usuario INT, id_predio INT, id_actividad INT, id_horario INT, fecha INT)***
>>
>> insertamos un turno
>
>> ***insertar_administrador(id_usuario INT,id_predio INT,id_actividad INT)***
>>
>> Insertamos un administrador por predio

> **Activacion de Cuentas:**
>
> *Procesos Almacenados*
>
>> ***activacion_usuario(id_usuario INT)***
>>
>> Activa la cuenta de usuario registrado, confirmando el correo
>
>> ***activacion_usuario_de_baja(id_usuario INT)***
>> 
>> Activamos la cuenta de un usuario que se a dado de baja
>
>> ***activacion_predio_de_baja(id_predio INT)***
>>
>> Activamos un predio que se a dado de baja
>
>> ***activacion_actividad_de_baja(id_actividad INT)***
>>
>> Activamos una actividad que se a dado de baja
>
>> ***activacion_administrador_de_baja(id_administrador INT)***
>>
>> Activamos un administrador que se dio de baja

> **Insertar Datos Secundarios:**
>
> *Funciones*
>
>> ***insertar_predios_anuncios(id_predio INT,titulo VARCHAR(200),descripcion VARCHAR(10000))***
>>
>> Insertamos un anuncio de predio
>
>> ***insertar_predio_comentario(id_predio INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000))***
>>
>> Insertamos un comentario como usuario a un predio
>
>> ***insertar_actividad_anuncios(id_actividad INT,titulo VARCHAR(200),descripcion VARCHAR(10000))***
>>
>> Creamos un anuncion en una actividad
>
>> ***insertar_actividad_comentario(id_actividad INT, id_usuario INT, anonimo BIT, calificacion ENUM("1","2","3","4","5"), comentario VARCHAR(10000))***
>>
>> Insertamos un comentario y calificacion acerca de la actividad
>
>> ***insertar_actividades_administradores(id_usuario INT,id_predio INT,id_actividad INT)***
>>
>> Asignamos el rol de administrador a un usuario sobre una actividad
>
>> ***insertar_actividad_horario(id_actividad INT,dia INT,hora_comienzo TIME,hora_finalizacion TIME)***
>>
>> Creacion de un horario para una actividad
>
>> ***insertar_actividad_dia_cerrados(id_actividad INT,fecha DATE)***
>>
>> Creamos una fecha de dia cerrado
>

> **Dar de baja un registro:**
>
> *Procesos Almacenados*
>
>> ***baja_usuario(id_usuario INT)***
>>
>> dar de baja un usuario cliente
>
>> ***baja_predio(id_predio INT)***
>>
>> dar de baja un predio
>
>> ***baja_actividades(id_actividad INT)***
>>
>> dar de baja una actividad de un predio
>
>> ***baja_turno(id_turno INT)***
>> 
>> dar de baja un turno
>
>> ***baja_predio(id_predio INT)***
>>
>> Damos de baja un predio
>

> **Funciones Extra:**
>> ***validar_email(email)***
>> Validamos un correo antes de insertarse
>