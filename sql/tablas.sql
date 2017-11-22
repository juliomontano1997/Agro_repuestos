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
    constraint FK_id_factura_productos_facturas foreign key (id_factura) references historial.facturas on delete cascade on update cascade,
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

--------------------Consultas------------------------------------

/*1)Ordena de mayor a menor los clientes segun las compras realizadas*/
SELECT p.nombre||' '||p.apellido1||' '||p.apellido2  "Nombre Completo", SUM(v.total) "Monto total comprado"
	FROM (SELECT per.cedula, nombre, apellido1, apellido2 FROM informacion.personas per INNER JOIN
	(SELECT cedula FROM informacion.persona_tipo WHERE tipo = 'C') t ON per.cedula = t.cedula )p
	INNER JOIN (SELECT total, cedula FROM historial.facturas) v
	ON v.cedula = p.cedula GROUP BY "Nombre Completo", v.total ORDER BY v.total;

/*2)Muestra de mayor a menor los empleados segun las ventas realizadas*/
SELECT p.nombre||' '||p.apellido1||' '||p.apellido2  "Nombre Completo", SUM(v.total) "Monto total vendido"
	FROM (SELECT per.cedula, nombre,apellido1,apellido2 FROM informacion.personas per INNER JOIN
	(SELECT cedula FROM informacion.persona_tipo WHERE tipo = 'C') t ON per.cedula = t.cedula )p
	INNER JOIN (SELECT total, cedula FROM historial.facturas) v
	ON v.cedula = p.cedula GROUP BY "Nombre Completo", v.total ORDER BY v.total;

/*3)Ordena los productos y el total comprado de estos de mayor a menor*/
SELECT p.nombre "Nombre del producto", SUM(f.precio_parcial) "Total vendido"
	FROM (SELECT id, nombre FROM inventario.productos) p INNER JOIN (SELECT id_producto, precio_parcial FROM historial.productos_facturas) f
	ON p.id = f.id_producto GROUP BY "Nombre del producto", f.precio_parcial ORDER BY f.precio_parcial;

/*4)Muestra los correos de los empleados de San Jose y San Carlos */
CREATE VIEW direccion_persona
AS
(
    SELECT d.cedula FROM
	informacion.direcciones d INNER JOIN informacion.distritos di ON d.id_distrito = di.id
	INNER JOIN informacion.cantones ca ON di.id_canton = ca.id INNER JOIN (SELECT id FROM informacion.provincias WHERE nombre = 'San Jose'
	or nombre = 'Alajuela') p ON ca.id_provincia = p.id
);

SELECT p.nombre||' '||p.apellido1||' '||p.apellido2 "Nombre Completo", c.correo "Correo"
	FROM (SELECT per.cedula, nombre,apellido1,apellido2 FROM informacion.personas per INNER JOIN
	(SELECT cedula from  informacion.persona_tipo WHERE tipo = 'E') t ON t.cedula = per.cedula) p
	INNER JOIN (SELECT cedula, correo FROM informacion.correos) c ON p.cedula = c.cedula INNER JOIN direccion_persona d ON d.cedula = p.cedula;

/*5)Muestra los numeros telefonicos y correos de los 5 clientes mas importantes*/
SELECT cL.n_c "Nombre Completo", c.correo "Correo", t.numero "Numero telefonico"
	FROM (SELECT p.cedula, p.nombre||' '||p.apellido1||' '||p.apellido2  "n_c", SUM(v.total) "Monto total comprado"
	FROM (SELECT per.cedula, nombre,apellido1,apellido2 FROM informacion.personas per INNER JOIN
	(SELECT cedula from  informacion.persona_tipo WHERE tipo = 'C') t ON t.cedula = per.cedula) p
	INNER JOIN (SELECT total, cedula FROM historial.facturas) v
	ON v.cedula = p.cedula GROUP BY "n_c", v.total, p.cedula ORDER BY v.total limit 5) cL
	INNER JOIN informacion.correos c ON c.cedula = cL.cedula INNER JOIN informacion.telefonos t ON t.cedula = cL.cedula;

/*6)Muestra el total de productos que contiene cada bodega*/
SELECT b.nombre "Nombre bodega", SUM(p.cantidad_producto) "Total de productos almacenados" FROM
	(SELECT id, nombre FROM inventario.bodegas) b INNER JOIN  (SELECT id_bodega, cantidad_producto FROM inventario.productos_bodegas) p
	ON b.id = p.id_bodega GROUP BY "Nombre bodega" ORDER BY "Total de productos almacenados";

/*7)Muestra el total pagado y la cantidad de veces utilizado de los tipos de pago que acepta la aplicación*/
SELECT f.tipo_pago "Tipo de pago", SUM(f.total) "Total pagado", COUNT(f.tipo_pago) "Cantidad de veces utilizado" FROM historial.facturas f
	GROUP BY "Tipo de pago" ORDER BY "Cantidad de veces utilizado";

/*8)La cantidad de pedidos de cada cliente*/
SELECT p.nombre||' '||p.apellido1||' '||p.apellido2 "Nombre Completo", COUNT(e.cedula) "Cantidad de pedidos" FROM
	(SELECT per.cedula, nombre, apellido1, apellido2 FROM informacion.personas per INNER JOIN
	(SELECT cedula from  informacion.persona_tipo WHERE tipo = 'C') t ON t.cedula = per.cedula) p INNER JOIN
	historial.envios e ON e.cedula = p.cedula GROUP BY "Nombre Completo";

/*9)Muestra el promedio de ventas del año 2016*/
SELECT COUNT(f.id)*SUM(f.total) "Promedio de ventas año 2016" FROM (SELECT per.cedula FROM informacion.personas per INNER JOIN
	(SELECT cedula from  informacion.persona_tipo WHERE tipo = 'C') t ON t.cedula = per.cedula) p
	INNER JOIN (SELECT id, total, cedula FROM historial.facturas f WHERE fecha > '01-01-16' and fecha < '01-01-17') f ON p.cedula = f.cedula;

/*10)Ordena todas las facturas de los proveedores segun la fecha*/
SELECT per.nombre "Nombre Proveedor", f.id "Identificador factura", f.fecha "Fecha" FROM
    (SELECT per.cedula, nombre FROM informacion.personas per INNER JOIN
    (SELECT cedula from  informacion.persona_tipo WHERE tipo = 'P') t ON t.cedula = per.cedula) per
	INNER JOIN historial.facturas f ON per.cedula = f.cedula ORDER BY f.fecha;