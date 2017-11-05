
--TELEFONO
CREATE DOMAIN
    t_telefono char(9) not null
    constraint CHK_telefono
    check (value similar to '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');

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
    check(value in ('Cheque','Efectivo','Tarjeta','Transferencia'));

CREATE DOMAIN 
    t_tipo 
    varchar(2) not null 
    constraint CHK_tipoPersona 
    check(value in ('A','AA', 'C', 'E'));

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
    constraint FK_cedula_login_information foreign key (cedula) references personas
);



--

create table productos
(
    id serial not null,
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
    constraint FK_cedula_direcciones foreign key (cedula) references personas,
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
create unique index I_personas on personas(cedula);
create unique index I_facturas on facturas(fecha);
create unique index I_producto_factura on productos_facturas(id_factura, id_producto);
create unique index I_productos on productos(id);
create unique index I_productos_bodegas on productos_bodegas(id_producto, id_bodega);


--   Usuarios
-- https://todopostgresql.com/crear-usuarios-postgresql/
--- se tiene que arreglar
CREATE USER administrador WITH PASSWORD 'administrador2017';
ALTER ROLE administrador WITH SUPERUSER;

CREATE USER usuario_normal WITH PASSWORD 'normal2017';


CREATE USER respaldo WITH PASSWORD 'respaldo2017';
-- https://www.nanotutoriales.com/como-crear-un-usuario-y-asignarle-permisos-en-postgresql
GRANT ALL PRIVILEGES ON DATABASE agrorepuestos to usuario_normal;
GRANT ALL PRIVILEGES ON DATABASE facturas to respaldo;
































/*
--   Prueba inserciones nivel 1

-- provincias
insert into provincias (nombre) values ('Alajuela');
-- personas
insert into personas values ('9-0130-0731', 'Julio Adan', 'Montano', 'Hernandez', false, 'A');
insert into personas values ('9-0130-0732', 'Julio', 'Montano', 'Hernandez', false, 'E');
-- camiones 
insert into camiones values('NDR-123',2400,'Camion color blanco', 'Diesel');
-- familias 
insert into familias(nombre, tipo_almacen, descripcion) values ('llantas', 'Bodega para llantas', 'Aqui van todas las llantas');


--   Prueba inserciones nivel 2

-- cantones
insert into cantones (nombre, id_provincia) values ('Upala', 1);
-- telefonos 
insert into telefonos values ('9-0130-0731', '8721-9049', true);
-- correos 
insert into correos values('9-0130-0731', 'Juliomontano008@gmail.com');
-- facturas 
insert into facturas (cedula, tipo_pago, fecha, tipo, total) values ('9-0130-0731', 'Tarjeta', '4/11/2017', true, 30030);
-- logins
--https://www.postgresql.org/message-id/fb73c1ee05072206023fe16b2a%40mail.gmail.com
insert into loginInformation values('9-0130-0731',md5 ('pg2017' || '9-0130-0731' || '008'));

-- prueba insericiones nivel 3
-- productos
insert  into productos values (1, 'Llanta firestone', 30000, '35x12.50R17LT', 1);
-- distritos
insert into distritos(nombre, id_canton) values ('San jose', 1);
-- bodegas
insert into bodegas (nombre, tipo_almacen, capacidad, id_distrito,direccion_exacta) values ('Bodega 1','Bodega para llantas', 100, 1, 'Costado sur de la parroquia San Jose');
-- productos en bodegas
insert into productos_bodegas values(1, 1, 20);
-- productos facturas
insert  into productos_facturas(1, 1, 10, 30000, 300000);

-- prueba inserciones nivel 4
-- envios
insert into envios(id_factura, cedula, placa, fecha) values  (1, '9-0130-0732', 'NDR-123', '4/11/2017');
-- direcciones
insert into direcciones values(1, '9-0130-0731', 'Costado sur escuela La victoria');



--   Pruebas eliminaciones













--insertando 
--insert into usuarios (id,login,password) values (nextval('secuencia'),  login  ,md5 ('password' || 'login' || currval('secuencia')|| 'tuvalorfijo' ) );

-- Autenticar al usuario:

--select id from usuarios where password = md5('password_insertado' || 'login_insertado' || id || 'tuvalorfijo' ) and login = 'login_insertado';
*/




