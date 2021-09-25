# Base de Datos

Se esta utilizando el DBMS MySQL.
La ejecucion de los archivos SQL debe de seguir un orden definido:

1. ```database.sql```
2. ```procesos-almacenados.sql```
3. ```funciones.sql```
4. ```triggers.sql```
5. ```eventos.sql```

Hacemos uso del usuario "USER_DML" con la contraseña "rivadavia" para el servidor.

## Funciones y Procesos Almacenados Disponibles para Interactuar con la BD

A continuación se mostrara las funciones y procesos almacenados que podemos ejecutar en la base de datos:

> **Inserción de datos primarios:** 
>
> *Procesos Almacenados*
> >
>> ***insertar_predio (id_propietario INT,email VARCHAR(200),nombre VARCHAR(400), telefono VARCHAR(100),descripcion VARCHAR(10000), provincia VARCHAR(200),localidad VARCHAR(200),direccion VARCHAR(1000))***
>> 
>> Insertamos un predio
> 
>> ***insertar_actividad(id_predio INT,nombre_actividad VARCHAR(400),telefono VARCHAR(100),usuarios_maximos_x_turno SMALLINT,descripcion VARCHAR(10000),foto_actividad MEDIUMBLOB)***
>>
>> Insertamos una actividad
>
>> ***insertar_turno(id_usuario INT, id_predio INT, id_actividad INT, id_horario INT, fecha INT)***
>>
>> insertamos un turno
>
>> ***insertar_administrador(id_usuario INT,id_predio INT,acceso_global BIT)***
>>
>> Insertamos un administrador por predio
>
>> ***insertar_administrador_actividades(id_administrador INT, id_actividad INT)***
>>
>> Sí un administrador no tiene el acceso global en el predio, debemos especificar las actividades a las que tiene acceso, mediante este proceso almacenado.
>

> **Activacion de Cuentas:**
>
> *Procesos Almacenados*
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
> *Procesos Almacenados*
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
>> ***insertar_predio_propietario (id_predio INT, id_usuario INT)***
>>
>> Insertamos un propietario de predio
>
>> ***insertar_usuario_predio_favorito(id_usuario INT,id_predio INT)***
>>
>> Insertamos un predio en favoritos de un usuario
>
>> insertar_usuario_actividad_favorito(id_usuario INT,id_actividad INT)
>>
>> Insertamos una actividad en favoritos de un usuario
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
>> ***baja_administrador_x_predio(id_administrador INT)***
>>
>> Damos de baja un administrador de predio
>
>> ***baja_administrador_x_actividad(id_administrador INT, id_actividad INT)***
>>
>> Le quitamos el acceso a una actividad de un administrador
>
>> ***baja_predio_propietario(id_propietario INT)***
>>
>> Le quitamos el estado de propietario de un predio
>

> **Funciones Extra:**
>> ***validar_email(email VARCHAR(200))***
>>
>> Validamos un correo antes de insertarse
>
>> ***validar_insertar_turno(id_usuario INT, id_actividad INT, id_horario INT, fecha DATE)***
>>
>> Validamos si un turno puede insertarse
>

> **Procesos Almacenados Extras:**
>> ***insert_log(tabla VARCHAR(100),campo_modificado VARCHAR(100),id INT,valor_nuevo VARCHAR(10000),valor_viejo VARCHAR(10000))***
>>
>> Insertamos un registro log a la tabla de logs
>> Utilizado para los triggers
>

# PHP composer

Se esta utilizando el gestor de independencias "composer", el archivo de ejecucion se encuentra en la ruta "api/composer/composer.json", debe ser ejecutado en esa misma carpeta