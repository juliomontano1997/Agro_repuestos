
--TELEFONO
CREATE DOMAIN
    t_telefono char(9) not null
    constraint CHK_telefono
    check (value similar to '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
-- true= celular false = casa 


--CORREO
CREATE DOMAIN
    t_correo varchar(50) not null
    constraint CHK_correo
    check (value similar to '[A-z]%@[A-z]%.[A-z]%');

--GENERO
CREATE DOMAIN
    t_genero boolean not null;

--CEDULA
CREATE DOMAIN
    t_cedula char(11) not null
    constraint CHK_cedula
    check (value similar to '[0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');

--PLACA DE LOS VEHICULOS
CREATE DOMAIN
    t_placa char(7) not null
    constraint CHK_placaFormato
    check (value similar to '[B-Z][B-Z][B-Z]-[0-9][0-9][0-9]' and value not in ('A','E','I','O','U'));

--DESCRIPCIONES
CREATE DOMAIN
    t_nombre varchar(20) ;

CREATE DOMAIN
    t_descripcion varchar(100);

-- TIPO
CREATE DOMAIN
    t_tipo_pago
    varchar(15) not null
    check(value in ('Cheque','Efectivo','Tarjeta','Transferencia', 'Especial'));

CREATE DOMAIN
    t_tipo
    varchar(2) not null
    constraint CHK_tipoPersona
    check(value in ('A','P','C', 'E'));

-- Tablas
create table provincias
(
    id serial not null,
    nombre t_nombre not null,
    constraint  PK_id_provincias primary key(id),
    constraint UNQ_nombre_provincias UNIQUE (nombre)
);


create table personas
(
    cedula t_cedula not null,
    nombre t_nombre not null,
    apellido1 t_nombre  not null,
    apellido2 t_nombre  not null,
    genero t_genero not null,
    tipo t_tipo,
    constraint PK_cedulaEmpleado_empleados primary key(cedula)
);


create table camiones
(
    placa t_placa not null,
    capacidad int not null CHECK (capacidad > 0),
    descripcion t_descripcion,
    tipo_combustible varchar(10),
    constraint PK_placa_camion primary key(placa)
);


create table familias
(
    id serial not null,
    nombre t_nombre not null,
    tipo_almacen  t_nombre not null,
    descripcion t_descripcion not null,
    constraint PK_codigoFamilia_familias primary key (id)
);

--TABLAS SECUNDARIAS

create table cantones
(
    id  serial not null,
    nombre t_nombre not null,
    id_provincia int not null,
    constraint  PK_id_cantones primary key(id),
    constraint FK_id_provincia_cantones_provincias foreign key(id_provincia) references provincias
);


create table telefonos
(
    cedula t_cedula not null,
    numero t_telefono not null,
    tipo boolean not null,
    constraint PK_cedula_numero_telefono primary key (cedula,numero),
    constraint FK_cedula_telefono_personas foreign key(cedula) references personas on delete cascade on update cascade
);


create table correos
(
    cedula  t_cedula not null,
    correo  t_correo not null,
    constraint PK_cedula_correo_personas primary key (cedula, correo),
    constraint FK_cedula_correos_personas foreign key(cedula) references personas on delete cascade on update cascade
);


create table facturas
(
    id serial not null,
    cedula t_cedula not null,
    tipo_pago t_tipo_pago,
    fecha date not null default now(),
    tipo boolean not null,
    total money not null default 0,
    constraint PK_id_facturas primary key(id)
);

create table informacion_usuarios
(
    cedula t_cedula ,
    lg_info varchar not null,
    constraint UNQ_cedula_loginInformation UNIQUE (cedula),
    constraint FK_cedula_login_information foreign key (cedula) references personas on delete cascade on update cascade
);

--

create table productos
(
    id  serial not null,
    nombre t_nombre not null,
    precio money not null,
    descripcion t_descripcion not null,
    id_familia  int not null,
    constraint PK_id_producto_nombre_productos primary key (id),
    constraint FK_id_familia_productos_familias foreign key (id_familia) references familias on delete cascade on update cascade
);



create table distritos
(
    id serial not null,
    nombre t_nombre not null,
    id_canton int not null,
    constraint  PK_idDistrito_distritos primary key(id),
    constraint Fk_id_canton_distritos_cantones foreign key (id_canton) references cantones
);

create table bodegas
(
    id serial not null,
    nombre t_nombre not null,
    tipo_almacen varchar not null,
    capacidad int not null,
    id_distrito int not null,
    direccion_exacta t_descripcion,
    constraint  PK_id_bodegas primary key(id),
    constraint FK_id_distrito_bodegas foreign key (id_distrito) references distritos
);


create table productos_bodegas
(
    id_bodega int not null,
    id_producto int not null,
    cantidad_producto int not null,
    constraint FK_id_bodega_bodegas_productos foreign key (id_bodega) references bodegas,
    constraint FK_id_producto_bodegas_productos foreign key (id_producto) references productos
);

create table productos_facturas
(
    id_factura int not null,
    id_producto int not null,
    cantidad int not null,
    precio_unitario money not null,
    precio_parcial money not null,
    constraint FK_id_factura_productos_facturas foreign key (id_factura) references facturas,
    constraint FK_id_producto_productos_facturas foreign key (id_producto) references productos
);



--

create table envios
(
    id serial not null,
    id_factura int not null,
    cedula t_cedula not null,
    placa t_placa not null,
    fecha date not null default now(),
    constraint FK_id_factura_envios foreign key (id_factura) references facturas,
    constraint FK_cedula_envios foreign key (cedula) references personas,
    constraint FK_placa_envios foreign key (placa) references camiones

);

create table direcciones
(
    id serial not null,
    id_distrito int not null,
    cedula t_cedula not null,
    direccion_exacta t_descripcion,
    constraint PK_id_direcciones primary key(id),
    constraint FK_cedula_direcciones foreign key (cedula) references personas on delete cascade on update cascade,
    constraint FK_id_distrito_direcciones foreign key (id_distrito) references distritos
);



-- Creacion de esquemas
-- https://www.postgresql.org/docs/8.1/static/sql-createschema.html

create schema informacion;
create schema historial;
create schema inventario;

-- movemos las tablas
-- https://www.postgresql.org/message-id/BAY104-W5126B6C843A0AB5536ADBDD10F0%40phx.gbl
alter table "public"."provincias"  set SCHEMA informacion;
alter table "public"."cantones"  set SCHEMA informacion;
alter table "public"."distritos"  set SCHEMA informacion;
alter table "public"."personas"  set SCHEMA informacion;
alter table "public"."informacion_usuarios"  set SCHEMA informacion;
alter table "public"."telefonos"  set SCHEMA informacion;
alter table "public"."correos"  set SCHEMA informacion;
alter table "public"."direcciones"  set SCHEMA informacion;


alter table "public"."facturas"  set SCHEMA historial;
alter table "public"."envios"  set SCHEMA historial;
alter table "public"."productos_facturas"  set SCHEMA historial;


alter table "public"."camiones"  set SCHEMA inventario;
alter table "public"."bodegas"  set SCHEMA inventario;
alter table "public"."productos"  set SCHEMA inventario;
alter table "public"."familias"  set SCHEMA inventario;
alter table "public"."productos_bodegas"  set SCHEMA inventario;




-- Nomenclatura para el nombre   I_nombretabla
-- http://www.tutorialesprogramacionya.com/postgresqlya/temarios/descripcion.php?cod=199&punto=41&inicio=
create unique index I_personas on informacion.personas(cedula);
create unique index I_facturas on historial.facturas(fecha);
create unique index I_producto_factura on historial.productos_facturas(id_factura, id_producto);
create unique index I_productos on inventario.productos(id);
create unique index I_productos_bodegas on inventario.productos_bodegas(id_producto, id_bodega);


-- Cambios
-- Usuarios
-- https://todopostgresql.com/crear-usuarios-postgresql/
-- Se tiene que arreglar: sirve pero hay que tener cuidado
/*
CREATE USER administrador WITH PASSWORD 'administrador2017';
ALTER ROLE administrador WITH SUPERUSER;
CREATE USER usuario_normal WITH PASSWORD 'normal2017';

GRANT ALL ON ALL TABLES IN SCHEMA "informacion" TO usuario_normal;
GRANT ALL ON ALL TABLES IN SCHEMA "historial" TO usuario_normal;
GRANT ALL ON ALL TABLES IN SCHEMA "inventario" TO usuario_normal;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "informacion" TO usuario_normal;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "historial" TO usuario_normal;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "inventario" TO usuario_normal;


CREATE USER respaldo WITH PASSWORD 'respaldo2017';
ALTER ROLE respaldo WITH REPLICATION;

*/
--------------------------------------------------   Metodos almacenados   -----------------------------------------------

-- provincias

CREATE OR REPLACE FUNCTION informacion.insertar_provincia(e_nombre t_nombre) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.provincias(nombre) VALUES (e_nombre);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_provincia(e_id int, e_nombre t_nombre) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.provincias SET nombre = e_nombre WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_provincia(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.provincias WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;

select informacion.insertar_provincia('Ganacaste');
/*select * from informacion.provincias;
select informacion.modificar_provincia(6, 'Guanacaste');
select * from informacion.provincias;
select informacion.eliminar_provincia(6);
select * from informacion.provincias;*/





-- personas 

CREATE OR REPLACE FUNCTION informacion.insertar_persona(cedula t_cedula, nombre t_nombre, apellido1 t_nombre, apellido2 t_nombre, genero boolean, tipo t_tipo ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.personas VALUES (cedula, nombre, apellido1, apellido2, genero, tipo);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_persona(ced t_cedula, nuevo_nombre t_nombre, nuevo_apellido1 t_nombre, nuevo_apellido2 t_nombre, nuevo_genero boolean, nuevo_tipo t_tipo ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.personas 
	SET (nombre, apellido1, apellido2, genero, tipo) = (nuevo_nombre, nuevo_apellido1, nuevo_apellido2,nuevo_genero,nuevo_tipo)
        WHERE cedula =ced;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

 

CREATE OR REPLACE FUNCTION informacion.eliminar_persona(e_cedula t_cedula)
RETURNS BOOLEAN AS
$body$
BEGIN	
	DELETE FROM informacion.personas WHERE cedula = e_cedula;	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;


select informacion.insertar_persona('9-0130-0731', 'Julio Adan', 'Montano', 'Hernandez', false, 'A');

/*SELECT * FROM informacion.personas;
select informacion.modificar_persona('9-0130-0731', 'Julio Adan', 'Montano', 'Hernandez', false, 'AA');
SELECT * FROM informacion.personas;
select informacion.eliminar_persona('9-0130-0731');
SELECT * FROM informacion.personas;*/



-- Familias 
CREATE OR REPLACE FUNCTION inventario.insertar_familia(e_nombre t_nombre,e_tipo_almacen t_nombre, e_descripcion t_descripcion) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.familias(nombre, tipo_almacen, descripcion) VALUES (e_nombre, e_tipo_almacen, e_descripcion);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.modificar_familia(e_id int, nuevo_nombre t_nombre,nuevo_tipo_almacen t_nombre, nuevo_descripcion t_descripcion) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.familias 
	SET (nombre, tipo_almacen,descripcion) = (nuevo_nombre, nuevo_tipo_almacen, nuevo_descripcion)
        WHERE id =e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.eliminar_familia(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN	
	DELETE FROM inventario.familias WHERE id = e_id;	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;


select inventario.insertar_familia('llantas', 'Bodega para llantas', 'Aqui van todas las llantas');
/*select * from inventario.familias;
select inventario.modificar_familia(2,'Llantas', 'Almacen para llantas', 'Aqui van todas las llantas');
select * from inventario.familias;
select inventario.eliminar_familia(3);
select * from inventario.familias;*/




-- Camiones 


CREATE OR REPLACE FUNCTION inventario.insertar_camion(placa t_placa, capacidad int , descripcion t_descripcion, tipo_combustible varchar(10)) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.camiones VALUES (placa,capacidad, descripcion, tipo_combustible);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.modificar_camion(o_placa t_placa, e_placa t_placa, e_capacidad int, e_descripcion t_descripcion, e_tipo_combustible varchar(10)) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.camiones 
	SET (placa,capacidad,descripcion, tipo_combustible) = (e_placa, e_capacidad, e_descripcion, e_tipo_combustible)
        WHERE placa = o_placa;
        RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.eliminar_camion(e_placa t_placa)
RETURNS BOOLEAN AS
$body$
BEGIN	
	DELETE FROM inventario.camiones WHERE placa= e_placa;	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;


select inventario.insertar_camion('NDR-123',2400,'Camion color blanco', 'Diesel');
/*select * from inventario.camiones;
select inventario.modificar_camion('NDR-123','NDR-321',2200,'Camion color rojo', 'Hidrogeno')
select * from inventario.camiones;
select inventario.eliminar_camion('NDR-321');
select * from inventario.camiones;*/




-- Nivel 2 


-- cantones
CREATE OR REPLACE FUNCTION informacion.insertar_canton(e_nombre t_nombre, e_id_provincia int ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.cantones(nombre, id_provincia) VALUES (e_nombre, e_id_provincia);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_canton(e_id int , e_nombre t_nombre, e_id_provincia int) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.cantones SET (nombre, id_provincia)= (e_nombre, id_provincia)
	WHERE id=e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_canton(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.cantones 
	WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;

select * from informacion.provincias;
select informacion.insertar_canton('Montes de Oca', 1);
/*select * from informacion.cantones;
select informacion.modificar_canton(2, 'Montes dee Oca', 1);
select * from informacion.cantones;
select informacion.eliminar_canton(2);
select * from informacion.cantones;*/







-- telefonos 

CREATE OR REPLACE FUNCTION informacion.insertar_telefono(e_cedula t_cedula, e_telefono t_telefono, e_tipo boolean) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.telefonos VALUES (e_cedula, e_telefono, e_tipo);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_telefono(e_cedula t_cedula,o_numero t_telefono, e_numero t_telefono, e_tipo boolean) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.telefonos SET (numero, tipo)=(e_numero, e_tipo)
	WHERE numero = o_numero AND cedula = e_cedula;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_telefono(e_cedula t_cedula, e_numero t_telefono)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.telefonos 
	WHERE cedula=e_cedula AND numero = e_numero;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select * from informacion.personas;
select informacion.insertar_telefono('9-0130-0731', '2721-9049', true);

select informacion.insertar_telefono('9-0130-0731', '3333-3333', true);

/*select * from informacion.telefonos;
select informacion.modificar_telefono('9-0130-0731','8721-9049', '8666-6017', false);
select * from informacion.telefonos;
select informacion.eliminar_telefono('9-0130-0731','8666-6017');
select * from informacion.telefonos;*/



CREATE OR REPLACE FUNCTION informacion.insertar_correo(e_cedula t_cedula, e_correo t_correo) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.correos VALUES  (e_cedula, e_correo);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_correo(e_cedula t_cedula, e_correo_anterior t_correo, e_correo_nuevo t_correo) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.correos SET (correo)= (e_correo_nuevo)
	WHERE cedula = e_cedula and e_correo_anterior=correo;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_correo(e_cedula t_cedula, e_correo t_correo)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.correos WHERE cedula = e_cedula AND correo=e_correo;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select * from informacion.correos;
select informacion.insertar_correo('9-0130-0731', 'juliomontano008@hot.com');
/*select * from informacion.correos;
select informacion.modificar_correo('9-0130-0731', 'juliomontano008@hotmail.com');
select * from informacion.correos;
select informacion.eliminar_correo('9-0130-0731', 'juliomontano008@hotmail.com');
select * from informacion.correos;*/




-- Contraseñas 

CREATE OR REPLACE FUNCTION informacion.insertar_informacion_usuario(e_cedula t_cedula, e_password varchar) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.informacion_usuarios VALUES (e_cedula, md5(e_password || e_cedula ||'azZA'));	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_informacion_usuario(e_cedula t_cedula, e_password varchar, e_n_password varchar) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.informacion_usuarios SET (lg_info) = ( md5(e_n_password || e_cedula ||'azZA')) WHERE lg_info = md5(e_password || e_cedula ||'azZA');
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

select * from informacion.informacion_usuarios


CREATE OR REPLACE FUNCTION informacion.eliminar_informacion_usuario(e_cedula t_cedula, e_password varchar) 
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.informacion_usuarios WHERE lg_info = md5(e_password || e_cedula ||'azZA'); 
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select informacion.insertar_informacion_usuario('9-0130-0731', 'prueba2017');
select * from informacion.informacion_usuarios;
/*select informacion.modificar_informacion_usuario('9-0130-0731', 'prueba2017', 'prueba2016');
select * from informacion.informacion_usuarios;
select informacion.eliminar_informacion_usuario('9-0130-0731', 'prueba2016');
select * from informacion.informacion_usuarios;*/







CREATE OR REPLACE FUNCTION historial.insertar_factura(e_cedula t_cedula, e_tipo_pago t_tipo_pago, e_fecha date, e_tipo boolean, e_total numeric) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO historial.facturas(cedula, tipo_pago, fecha, tipo, total) VALUES (e_cedula, e_tipo_pago, e_fecha, e_tipo, e_total);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE 
FUNCTION historial.modificar_factura(id_factura int , e_cedula t_cedula, e_tipo_pago t_tipo_pago, e_fecha date, e_tipo boolean, e_total numeric)
RETURNS BOOLEAN AS
$body$
BEGIN	
	UPDATE historial.facturas SET (id,cedula,tipo_pago,fecha, tipo,total)=(id_factura, e_cedula, e_tipo_pago, e_fecha, e_tipo,e_total) 
	WHERE id = id_factura;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.eliminar_factura(id_factura int )
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM historial.facturas WHERE id = id_factura;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;




select historial.insertar_factura('9-0130-0731', 'Tarjeta', '4/11/2017', true, 30030);
/*select * from historial.facturas;
select historial.modificar_factura(3,'9-0130-0731', 'Tarjeta', '4/11/2017', true, 30000);
select * from historial.facturas;
select historial.eliminar_factura(2);
select * from historial.facturas;*/




CREATE OR REPLACE FUNCTION inventario.insertar_producto(e_nombre t_nombre, e_precio numeric , e_descripcion t_descripcion, e_id_familia int) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.productos (nombre, precio, descripcion, id_familia) VALUES (e_nombre, e_precio, e_descripcion, e_id_familia);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.modificar_producto(e_id int, e_nombre t_nombre, e_precio numeric , e_descripcion t_descripcion, e_id_familia int ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.productos SET (nombre, precio, descripcion, id_familia) =(e_nombre, e_precio, e_descripcion, e_id_familia) WHERE id=e_id ;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.eliminar_producto(e_id int )
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.productos WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select inventario.insertar_producto('Llanta firestone', 30000, '35x12.50R17LT', 1);
/*select * from inventario.productos;
select inventario.modificar_producto(1, 'Llanta firestone', 25000, '35x12.50R17LT', 1);
select * from inventario.productos;
select inventario.eliminar_producto(1);
select * from inventario.productos;*/



select * from informacion.distritos;
CREATE OR REPLACE FUNCTION informacion.insertar_distrito(e_id_canton int,e_nombre t_nombre) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.distritos(nombre, id_canton) VALUES (e_nombre, e_id_canton);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_distrito(e_id int ,e_nombre t_nombre, e_id_canton int) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.distritos SET (nombre, id_canton)= (e_nombre, e_id_canton) WHERE id= e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_distrito(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.distritos WHERE id= e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select informacion.insertar_distrito(1, 'San Pedro'); 
/*select informacion.modificar_distrito(1, 'San pedro', 1);
elect informacion.eliminar_distrito(1);*/



CREATE OR REPLACE FUNCTION informacion.insertar_direccion( e_id_distrito int ,e_cedula t_cedula, e_direccion t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.direcciones(id_distrito,cedula,direccion_exacta) VALUES (e_id_distrito,e_cedula,e_direccion);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_direccion(e_id int ,e_id_distrito int, e_cedula t_cedula, e_direccion t_descripcion) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.direcciones SET (id_distrito, cedula, direccion_exacta)=(e_id_distrito, e_cedula, e_direccion) WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_direccion(e_id int )
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.direcciones WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select informacion.insertar_direccion(1,'9-0130-0731','Costado sur escuela La victoria');
/*select informacion.modificar_direccion(1,2,'9-0130-0731','Costado norte escuela La victoria');
select informacion.eliminar_direccion(1);*/


select * from historial.productos_facturas;

CREATE OR REPLACE FUNCTION historial.insertar_producto_factura(id_factura int , id_producto int, cantidad_producto int, precio numeric) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO historial.productos_facturas VALUES (id_factura, id_producto, cantidad_producto, precio,precio*cantidad_producto);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.modificar_producto_factura(e_id_factura int, e_id_producto int, e_cantidad int, e_precio numeric) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE historial.productos_facturas SET (cantidad, precio_unitario, precio_parcial)= (e_cantidad, e_precio, e_cantidad*e_precio) WHERE id_factura= e_id_factura AND id_producto = e_id_producto;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.eliminar_producto_factura(e_id_factura int, e_id_producto int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM historial.productos_facturas WHERE  id_factura = e_id_factura AND id_producto = e_id_producto;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;


select historial.insertar_producto_factura(1, 1, 10, 30000);
/*select * from historial.productos_facturas;
select historial.modificar_producto_factura(3,2,5,30000);
select * from historial.productos_facturas;
select historial.eliminar_producto_factura(3,2);
select * from historial.productos_facturas;*/



select * from inventario.bodegas;
CREATE OR REPLACE FUNCTION inventario.insertar_bodega(e_nombre t_nombre, e_tipo_almacen varchar, e_capacidad int, e_id_distrito int, e_direccion_exacta t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.bodegas (nombre, tipo_almacen, capacidad, id_distrito, direccion_exacta)
	VALUES(e_nombre, e_tipo_almacen, e_capacidad, e_id_distrito, e_direccion_exacta);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.modificar_bodega(e_id int, e_nombre t_nombre, e_tipo_almacen varchar, e_capacidad int, e_id_distrito int, e_direccion_exacta t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.bodegas 
	SET (nombre, tipo_almacen, capacidad, id_distrito, direccion_exacta)=(e_nombre, e_tipo_almacen, e_capacidad, e_id_distrito, e_direccion_exacta)
	WHERE id = e_id;	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.eliminar_bodega(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.bodegas WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;

select * from informacion.distritos;
select inventario.insertar_bodega('Bodega 1','Bodega para llantas', 100, 1, 'Costado sur de la parroquia San Jose');
/*select * from inventario.bodegas;
select inventario.modificar_bodega(3,'Bodega 1','Bodega para llantas', 100, 2, 'Costado norte');
select * from inventario.bodegas;
select inventario.eliminar_bodega(3);*/


CREATE OR REPLACE FUNCTION inventario.insertar_producto_bodega(e_id_bodega int, e_id_producto int, e_cantidad int ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.productos_bodegas VALUES (e_id_bodega, e_id_producto, e_cantidad);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.modificar_producto_bodega(e_id_bodega int, e_id_producto int, e_cantidad int) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.productos_bodegas SET (cantidad_producto)=(e_cantidad) WHERE id_bodega = e_id_bodega AND id_producto = e_id_producto;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.eliminar_producto_bodega(e_id_bodega int, e_id_producto int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.productos_bodegas
	WHERE id_bodega = e_id_bodega AND id_producto = e_id_producto;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;


select inventario.insertar_producto_bodega(1,1, 20);
/*select * from inventario.productos_bodegas;
select inventario.modificar_producto_bodega(4,2,10);
select inventario.eliminar_producto_bodega(4,2);*/



CREATE OR REPLACE FUNCTION historial.insertar_envio(e_id_factura int, e_cedula t_cedula, e_placa t_placa, e_fecha date ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO historial.envios(id_factura, cedula, placa, fecha) VALUES (e_id_factura, e_cedula, e_placa, e_fecha);	
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.modificar_envio(e_id int,e_id_factura int, e_cedula t_cedula, e_placa t_placa, e_fecha date ) 
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE historial.envios SET (id_factura, cedula, placa, fecha)=(e_id_factura, e_cedula, e_placa, e_fecha) 
	WHERE id=e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;	
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.eliminar_envio(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM historial.envios WHERE id=e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;		
END;
$body$
LANGUAGE plpgsql;

select * from historial.envios;
select * from historial.facturas;
select * from informacion.personas;
select * from inventario.camiones;

select historial.insertar_envio(1,'9-0130-0731','NDR-123','11/11/2017');
/*select * from historial.envios;
select historial.modificar_envio(2,3,'9-0130-0731','NDR-123','11/12/2017');
select * from historial.envios;
select historial.eliminar_envio(1);
select * from historial.envios;*/






------------------------------------  mas funciones --------------------------------------------- 




CREATE OR REPLACE FUNCTION informacion.mg_login(e_cedula t_cedula, e_password varchar)
RETURNS BOOLEAN AS
$body$
BEGIN
	IF (SELECT COUNT(cedula) FROM informacion.informacion_usuarios WHERE lg_info = md5(e_password || e_cedula ||'azZA')) = 0 THEN
		RETURN FALSE;
	ELSE 
		RETURN TRUE;
	END IF;
END;
$body$
LANGUAGE plpgsql;


select informacion.mg_login('9-0130-0731', 'prueba2017');
-- Falta seguridad
CREATE OR REPLACE FUNCTION informacion.mg_get_personas_tipo(IN e_tipo t_tipo, OUT r_cedula t_cedula, OUT r_nombre t_nombre, OUT r_apellido1 t_nombre, OUT r_apellido2 t_nombre, OUT r_genero t_genero)
RETURNS 
SETOF RECORD AS 
$body$
BEGIN 
	RETURN query SELECT cedula, nombre, apellido1, apellido2, genero FROM informacion.personas where tipo = e_tipo;
END;
$body$
LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION informacion.mg_get_provincias(OUT r_id int, OUT r_nombre t_nombre)
RETURNS 
SETOF RECORD AS 
$body$
BEGIN 

	RETURN query SELECT * FROM informacion.provincias;
END;
$body$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION informacion.mg_get_telefonos_usuario(IN e_cedula t_cedula,OUT r_numero t_telefono, OUT r_tipo boolean)
RETURNS 
SETOF RECORD AS 
$body$
BEGIN 	
	RETURN query SELECT numero, tipo FROM informacion.telefonos where cedula = e_cedula ;
END;
$body$
LANGUAGE plpgsql;

select * from informacion.telefono

CREATE OR REPLACE FUNCTION informacion.mg_get_correos_usuario(IN e_cedula t_cedula,OUT r_cedula t_cedula,  OUT r_correo t_correo)
RETURNS 
SETOF RECORD AS 
$body$
BEGIN 	
	RETURN query SELECT * FROM informacion.correos where cedula = e_cedula ;
END;
$body$
LANGUAGE plpgsql;

select informacion.mg_get_correos_usuario('9-0130-0731');

DROP FUNCTION informacion.mg_get_persona(t_cedula);

CREATE OR REPLACE FUNCTION informacion.mg_get_persona(IN e_cedula t_cedula, OUT r_nombre t_nombre, OUT r_apellido1 t_nombre, OUT r_apellido2 t_nombre, OUT r_genero t_genero)
RETURNS
SETOF RECORD AS 
$body$
BEGIN 	
	RETURN query SELECT nombre, apellido1, apellido2,genero FROM informacion.personas where cedula = e_cedula ;
END;
$body$
LANGUAGE plpgsql;

select * from informacion.personas;
select informacion.mg_get_persona('9-0130-0731');

DROP FUNCTION informacion.mg_get_direcciones(t_cedula)


CREATE OR REPLACE FUNCTION informacion.mg_get_direcciones(IN e_cedula t_cedula,
			 OUT r_id_distrito int,
			 OUT r_direccion t_descripcion,
			 OUT r_provincia t_nombre, 
			 OUT r_canton t_nombre, 
			 OUT r_distrito t_nombre,
			 OUT r_id_direccion INT)
RETURNS
SETOF RECORD AS 
$body$
BEGIN 	
	RETURN query 
	SELECT 	
		distritos.id,
		direcciones.direccion_exacta,
		provincias.nombre, 		
		cantones.nombre, 
		distritos.nombre, 
		direcciones.id					
	
		 
	FROM	  	
	informacion.direcciones
	INNER JOIN 	
	(SELECT cedula FROM informacion.personas WHERE personas.cedula = e_cedula) as persona
	ON persona.cedula = direcciones.cedula
	
	INNER JOIN
	informacion.distritos
	on distritos.id = direcciones.id_distrito
	
	INNER JOIN 
	informacion.cantones	
	on cantones.id = distritos.id_canton
	
	INNER JOIN 
	informacion.provincias
	on cantones.id_provincia = provincias.id;
END;	
$body$
LANGUAGE plpgsql;


select informacion.mg_get_direcciones('9-0130-0731');




CREATE OR REPLACE FUNCTION informacion.mg_get_distritos (OUT r_id int,OUT r_nombre t_nombre)
RETURNS
SETOF RECORD AS 
$body$
BEGIN 	
	RETURN query SELECT  id, nombre FROM informacion.distritos;
END;
$body$
LANGUAGE plpgsql;


select informacion.mg_get_distritos()








/*1)Ordena de mayor a menor los clientes segun las compras realizadas*/
SELECT p.nombre||' '||p.apellido1||' '||p.apellido2  "Nombre Completo", SUM(v.total) "Monto total comprado"
	FROM (SELECT cedula, nombre,apellido1,apellido2 FROM personas WHERE tipo = 'C') p INNER JOIN (SELECT total, cedula FROM facturas) v
	ON v.cedula = p.cedula GROUP BY "Nombre Completo", v.total ORDER BY v.total;

/*2)Muestra de mayor a menor los empleados segun las ventas realizadas*/
SELECT p.nombre||' '||p.apellido1||' '||p.apellido2  "Nombre Completo", SUM(v.total) "Monto total vendido"
	FROM (SELECT cedula, nombre,apellido1,apellido2 FROM personas WHERE tipo = 'E') p INNER JOIN (SELECT total, cedula FROM facturas) v
	ON v.cedula = p.cedula GROUP BY "Nombre Completo", ORDER BY v.total;

/*3)Ordena los productos y el total comprado de estos de mayor a menor*/
SELECT p.nombre "Nombre del producto", SUM(f.precio_parcial) "Total vendido"
	FROM (SELECT id, nombre FROM productos) p INNER JOIN (SELECT id_producto, precio_parcial FROM productos_facturas) f
	ON p.id = f.id_producto GROUP BY "Nombre del producto", f.precio_parcial ORDER BY f.precio_parcial;

/*4)Muestra los correos de los empleados de San Jose y San Carlos */
CREATE VIEW direccion_persona
AS
(
    SELECT d.cedula FROM
	direcciones d INNER JOIN distritos di ON d.id_distrito = di.id
	INNER JOIN cantones ca ON di.id_canton = ca.id INNER JOIN (SELECT id FROM provincias WHERE nombre = 'San Jose'
	or nombre = 'Alajuela') p ON ca.id_provincia = p.id
);


SELECT p.nombre||' '||p.apellido1||' '||p.apellido2 "Nombre Completo", c.correo "Correo"
	FROM (SELECT cedula, nombre,apellido1,apellido2 FROM personas WHERE tipo = 'E') p INNER JOIN
        (SELECT cedula, correo FROM correos) c ON p.cedula = c.cedula INNER JOIN direccion_persona d ON d.cedula = p.cedula;


/*5)Muestra los numeros telefonicos y correos de los 5 clientes mas importantes*/
SELECT cL.n_c "Nombre Completo", c.correo "Correo", t.numero "Numero telefonico"
	FROM (SELECT p.cedula, p.nombre||' '||p.apellido1||' '||p.apellido2  "n_c", SUM(v.total) "Monto total comprado"
	FROM (SELECT cedula, nombre,apellido1,apellido2 FROM personas WHERE tipo = 'C') p INNER JOIN (SELECT total, cedula FROM facturas) v
	ON v.cedula = p.cedula GROUP BY "n_c", v.total, p.cedula ORDER BY v.total limit 5) cL
	INNER JOIN correos c ON c.cedula = cL.cedula INNER JOIN telefonos t ON t.cedula = cL.cedula;


/*6)Muestra el total de productos que contiene cada bodega*/
SELECT b.nombre "Nombre bodega", SUM(p.cantidad_producto) "Total de productos almacenados" FROM
	(SELECT id, nombre FROM bodegas) b INNER JOIN  (SELECT id_bodega, cantidad_producto FROM productos_bodegas) p
	ON b.id = p.id_bodega GROUP BY "Nombre bodega" ORDER BY "Total de productos almacenados";

/*7)Muestra el total pagado y la cantidad de veces utilizado de los tipos de pago que acepta la aplicación*/
SELECT f.tipo_pago "Tipo de pago", SUM(f.total) "Total pagado", COUNT(f.tipo_pago) "Cantidad de veces utilizado" FROM facturas f
	GROUP BY "Tipo de pago" ORDER BY "Cantidad de veces utilizado";

/*8)La cantidad de pedidos de cada cliente*/
SELECT p.nombre||' '||p.apellido1||' '||p.apellido2 "Nombre Completo", COUNT(e.cedula) "Cantidad de pedidos" FROM
	(SELECT cedula, nombre, apellido1, apellido2 FROM personas WHERE tipo = 'C') p INNER JOIN
	envios e ON e.cedula = p.cedula GROUP BY "Nombre Completo";

/*9)Muestra el promedio de ventas del año 2016*/
SELECT COUNT(f.id)*SUM(f.total) "Promedio de ventas año 2016" FROM (SELECT cedula FROM personas WHERE tipo = 'C') p
	INNER JOIN (SELECT id, total, cedula FROM facturas f WHERE fecha > '01-01-16' and fecha < '01-01-17') f ON p.cedula = f.cedula;

/*10)Ordena todas las facturas de los proveedores segun la fecha*/
SELECT per.nombre "Nombre Proveedor", f.id "Identificador factura", f.fecha "Fecha" FROM (SELECT cedula, nombre FROM personas WHERE tipo = 'P') per
	INNER JOIN facturas f ON per.cedula = f.cedula ORDER BY f.fecha;