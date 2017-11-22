/*
 Este script esta dirigido a la creacion de una base de datos relacionada
 a una empresa que vende repuestos para maquinaria agricola, y autos.

-- Dominios

--TELEFONO
-- true= celular false = casa
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
    t_nombre varchar(30) not null;

CREATE DOMAIN
    t_descripcion varchar(100) not null;

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

*/
--Creacion de esquemas

create schema informacion;
create schema historial;
create schema inventario;

-- Tablas

-- Primer nivel 

create table informacion.provincias
(
    id serial not null,
    nombre t_nombre not null,
    constraint  PK_id_provincias primary key(id),
    constraint UNQ_nombre_provincias UNIQUE (nombre)
);


create table inventario.camiones
(
    placa t_placa,
    capacidad int not null CHECK (capacidad > 0),
    descripcion t_descripcion,
    tipo_combustible varchar(10),
    constraint PK_placa_camion primary key(placa)
);


create table inventario.familias
(
    id serial not null,
    nombre t_nombre not null,
    tipo_almacen  t_nombre not null,
    descripcion t_descripcion not null,
    constraint PK_codigoFamilia_familias primary key (id)
);


-- Problemas 
create table informacion.personas
(
    cedula t_cedula,
    nombre t_nombre,
    apellido1 t_nombre,
    apellido2 t_nombre,
    genero t_genero,    
    primary key(cedula)
);

-- Segundo nivel 

create table informacion.persona_tipo
(
    cedula t_cedula,
    tipo t_tipo,
    constraint FK_tipo_persona_tipo foreign key (cedula) references informacion.personas on delete cascade on update cascade
);

create table informacion.telefonos
(
    cedula t_cedula,
    numero t_telefono not null,
    tipo boolean not null,    
    constraint PK_cedula_numero_telefono primary key (cedula,numero), 
    constraint FK_cedula_telefonos_persona foreign key(cedula) references informacion.personas(cedula) on delete cascade on update cascade
);


create table informacion.correos
(
    cedula  t_cedula not null, 
    correo  t_correo not null,    
    constraint PK_cedula_correo_persona primary key (cedula, correo),
    constraint FK_cedula_correos_persona foreign key(cedula) references informacion.personas on delete cascade on update cascade
);




create table historial.facturas
(
    id serial not null,
    cedula t_cedula,
    detalle t_descripcion,
    tipo_pago t_tipo_pago,
    fecha date not null default now(),
    tipo boolean not null,
    total money not null default 0,
    constraint PK_id_facturas primary key(id)    
);

create table informacion.cantones
(
    id  serial not null,
    nombre t_nombre not null,
    id_provincia int not null,
    constraint  PK_id_cantones primary key(id),
    constraint FK_id_provincia_cantones_provincias foreign key(id_provincia) references informacion.provincias
);


create table informacion.informacion_usuarios
(
    cedula t_cedula,    
    lg_info varchar not null,
    constraint UNQ_cedula_loginInformation UNIQUE (cedula),
    constraint FK_cedula_login_information foreign key (cedula) references informacion.personas on delete cascade on update cascade
);


create table inventario.productos
(
    id  serial not null,
    nombre t_nombre not null,
    precio money not null,
    descripcion t_descripcion not null,
    id_familia  int not null,
    constraint PK_id_producto_nombre_productos primary key (id),
    constraint FK_id_familia_productos_familias foreign key (id_familia) references inventario.familias on delete cascade on update cascade
);



-- Tercer nivel 
create table informacion.distritos
(
    id serial not null,
    nombre t_nombre not null,
    id_canton int not null,
    constraint  PK_idDistrito_distritos primary key(id),
    constraint Fk_id_canton_distritos_cantones foreign key (id_canton) references informacion.cantones
);

create table historial.productos_facturas
(
    id_factura int not null,
    id_producto int not null,
    cantidad int not null,
    precio_unitario money not null,
    precio_parcial money not null,
    constraint FK_id_factura_productos_facturas foreign key (id_factura) references historial.facturas,
    constraint FK_id_producto_productos_facturas foreign key (id_producto) references inventario.productos
);


create table historial.envios
(
    id serial not null,
    id_factura int not null,
    cedula t_cedula not null,
    placa t_placa not null,
    fecha date not null default now(),
    constraint FK_id_factura_envios foreign key (id_factura) references historial.facturas,
    constraint FK_cedula_envios foreign key (cedula) references informacion.personas,
    constraint FK_placa_envios foreign key (placa) references inventario.camiones on update cascade
);

-- Cuarto nivel 

create table informacion.direcciones
(
    id serial not null,
    id_distrito int not null,
    cedula t_cedula not null,
    direccion_exacta t_descripcion,
    constraint PK_id_direcciones primary key(id),
    constraint FK_cedula_direcciones foreign key (cedula) references informacion.personas on delete cascade on update cascade,
    constraint FK_id_distrito_direcciones foreign key (id_distrito) references informacion.distritos
);
create TABLE inventario.bodegas
(
    id serial not null,
    nombre t_nombre not null,
    tipo_almacen varchar not null,
    capacidad int not null,
    id_distrito int not null,
    direccion_exacta t_descripcion,
    constraint  PK_id_bodegas primary key(id),
    constraint FK_id_distrito_bodegas foreign key (id_distrito) references informacion.distritos
);



-- Quinto nivel 

create table inventario.productos_bodegas
(
    id_bodega int not null,
    id_producto int not null,
    cantidad_producto int not null,
    constraint FK_id_bodega_bodegas_productos foreign key (id_bodega) references inventario.bodegas,
    constraint FK_id_producto_bodegas_productos foreign key (id_producto) references inventario.productos
);


-- Nomenclatura para el nombre   I_nombretabla
-- http://www.tutorialesprogramacionya.com/postgresqlya/temarios/descripcion.php?cod=199&punto=41&inicio=
create unique index I_personas on informacion.personas(cedula);
create unique index I_facturas on historial.facturas(fecha);
create unique index I_producto_factura on historial.productos_facturas(id_factura, id_producto);
create unique index I_productos on inventario.productos(id);
create unique index I_productos_bodegas on inventario.productos_bodegas(id_producto, id_bodega);

/*
-- Cambios
-- Usuarios
-- https://todopostgresql.com/crear-usuarios-postgresql/
-- Se tiene que arreglar

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


--select informacion.mg_get_correos('1-0000-1111')
--select *  from informacion.correos
*/


INSERT INTO informacion.personas (cedula, nombre, apellido1, apellido2, genero) VALUES
('1-0000-1111','Ana','Rojas' ,'Podriguez' ,true),
('2-0000-1111','Federico','Boza' ,'Segura',false),
('3-1111-0000','Juan','Zocorro' ,'Mora',false),
('4-3333-1111','Jay','Garcia' ,'Lopez' ,false),
('5-1234-1234','Natalia','Arce','Sanchez',true),
('6-5678-5678','Laura','Fuentes' ,'Castro',true);


INSERT INTO informacion.persona_tipo VALUES
('1-0000-1111','E'),
('2-0000-1111','C'),
('3-1111-0000','P'),
('4-3333-1111','E'),
('5-1234-1234','A'),
('6-5678-5678','P');

------------------------Correos-----------------------------
INSERT INTO informacion.correos (cedula,correo) VALUES
('1-0000-1111','sbozda2@gmail.com'),
('2-0000-1111','sfzas2@gmail.com'),
('3-1111-0000','sbo2@gmail.com'),
('4-3333-1111','sas2@gmail.com'),
('5-1234-1234','soza@gmfail.com'),
('6-5678-5678','fzas2@gmail.com');

----------------------Telefonos-------------------------------
INSERT INTO informacion.telefonos (cedula,numero,tipo) VALUES
('1-0000-1111','9010-1111',true),
('2-0000-1111','4292-2346',false),
('3-1111-0000','1030-1111',true),
('4-3333-1111','4682-2211',false),
('5-1234-1234','1030-1111',true),
('6-5678-5678','4682-2211',false);

---------------------Provincias-------------------------------
INSERT INTO informacion.provincias (nombre) VALUES
('San José'),
('Alajuela'),
('Cartago'),
('Heredia'),
('Guanacaste'),
('Puntarenas'),
('Limón');

----------------------Cantones--------------------------------
INSERT INTO informacion.cantones (nombre, id_provincia) VALUES
    ('San Carlos',2),
    ('Upala',2),
    ('Los Chiles',2);

---------------------Distritos-------------------------------
INSERT INTO informacion.distritos (nombre, id_canton) VALUES
    ('Quesada',1),
    ('Florencia',1),
    ('La Fortuna',1);

---------------------Direcciones----------------------------
INSERT INTO informacion.direcciones (id_distrito, cedula, direccion_exacta) VALUES
(1,'1-0000-1111','dir_exacta'),
(2,'3-1111-0000','dir_exacta'),
(3,'6-5678-5678','dir_exacta');

---------------------Familias---------------------------------
INSERT INTO inventario.familias (nombre,tipo_almacen,descripcion) VALUES
('Llantas','almacen','descripcion'),
('Cadenas','almacen','descripcion'),
('Aceite','almacen','descripcion');

---------------------Productos---------------------------------
INSERT INTO inventario.productos (nombre, precio, descripcion, id_familia) VALUES
('Firestone',25000,'descripcion',1),
('Cadena moto',12500,'descripcion',2),
('Castrol',10500,'descripcion',3);



insert into inventario.camiones values
('NDR-123', 3000, 'Camion mediano blanco', 'Gasolina'),
('NDR-321', 5000, 'Camion mediano negro', 'Diesel');

select * from inventario.camiones