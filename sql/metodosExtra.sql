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




-- Retorna las personas de un determinado tipo 
CREATE OR REPLACE FUNCTION informacion.mg_get_personas_tipo(IN e_tipo t_tipo, OUT r_cedula t_cedula,OUT r_nombre t_nombre, OUT r_apellido1 t_nombre, OUT r_apellido2 t_nombre, OUT r_genero t_genero)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT personas.cedula, nombre, apellido1, apellido2, genero FROM
		informacion.personas 
		inner join
		informacion.persona_tipo
		on personas.cedula = persona_tipo.cedula 
		where tipo = e_tipo;
END;
$body$
LANGUAGE plpgsql;






CREATE OR REPLACE FUNCTION informacion.mg_get_direcciones(IN e_cedula t_cedula,OUT r_id_distrito int,OUT r_direccion t_descripcion,OUT r_provincia t_nombre, OUT r_canton t_nombre, OUT r_distrito t_nombre,OUT r_id_direccion INT)
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


-- retorna todos los distritos
CREATE OR REPLACE FUNCTION informacion.mg_get_distritos (OUT r_id int,OUT r_nombre t_nombre)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT  id, nombre FROM informacion.distritos;
END;
$body$
LANGUAGE plpgsql;

-- retorna todos los distritos
CREATE OR REPLACE FUNCTION informacion.mg_get_cantones(OUT r_id int,OUT r_nombre t_nombre)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT  id, nombre FROM informacion.cantones;
END;
$body$
LANGUAGE plpgsql;
-- retorna todos los distritos
CREATE OR REPLACE FUNCTION informacion.mg_get_provincias (OUT r_id int,OUT r_nombre t_nombre)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT  id, nombre FROM informacion.provincias;
END;
$body$
LANGUAGE plpgsql;

-- Permite obtener la infomacion de una persona en especifico

CREATE OR REPLACE FUNCTION informacion.mg_get_persona(IN e_cedula t_cedula, OUT r_nombre t_nombre,
						     OUT r_apellido1 t_nombre, OUT r_apellido2 t_nombre, OUT r_genero BOOLEAN)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT * from informacion.personas WHERE personas.cedula = e_cedula;
END;
$body$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION informacion.mg_get_telefonos_usuario(IN e_cedula  t_cedula, OUT r_numero t_telefono, OUT r_tipo boolean)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT numero,tipo FROM informacion.telefonos where cedula = e_cedula;
END;
$body$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION informacion.mg_get_correos_usuario(IN e_cedula  t_cedula, OUT r_correo t_correo, OUT r_cedula t_cedula)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT correo,cedula FROM informacion.correos where cedula = e_cedula;
END;
$body$
LANGUAGE plpgsql;



--  Permite obtener las familias de productos

CREATE OR REPLACE FUNCTION inventario.mg_get_familias(OUT r_id INT, OUT r_nombre t_nombre, OUT r_tipo_almacen t_nombre, OUT r_descripcion t_descripcion)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT  * from inventario.familias;
END;
$body$
LANGUAGE plpgsql;



-- Permite obtener todos los productos

CREATE OR REPLACE FUNCTION inventario.mg_get_productos(OUT r_id INT, OUT r_nombre t_nombre, OUT r_precio NUMERIC, OUT r_descripcion t_descripcion, OUT r_id_familia INT, OUT r_nombre_familia t_nombre)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT  productos.id, productos.nombre, productos.precio::NUMERIC, productos.descripcion,familias.id, familias.nombre from
		inventario.productos
		inner join
		inventario.familias
		on productos.id_familia= familias.id;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.mg_get_camiones(OUT r_placa t_placa, OUT r_capacidad INT,OUT r_descripcion t_descripcion,OUT r_combustible varchar(10))
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT * from inventario.camiones;

END;
$body$
LANGUAGE plpgsql;



-- Permite obtener las bodegas

CREATE OR REPLACE FUNCTION inventario.mg_get_bodegas(OUT r_id INT, OUT r_nombre t_nombre, OUT r_tipo_almacen varchar, OUT r_capacidad INT, OUT r_provincia t_nombre, OUT r_canton t_nombre,OUT r_distrito t_nombre,OUT r_id_distrito INT, OUT r_direccion_exacta t_descripcion)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT bodegas.id, bodegas.nombre, bodegas.tipo_almacen, bodegas.capacidad, provincias.nombre, cantones.nombre,distritos.nombre, bodegas.id_distrito,bodegas.direccion_exacta  from
		inventario.bodegas
		inner join
		informacion.distritos
		on bodegas.id_distrito = distritos.id
		inner join
		informacion.cantones
		on cantones.id = distritos.id_canton
		inner join
		informacion.provincias
		on  cantones.id_provincia= provincias.id;
END;
$body$
LANGUAGE plpgsql;


-- Permite obtener la informacion de los productos almacenados en una bodega

CREATE OR REPLACE FUNCTION inventario.mg_get_productos_bodega(IN id_almacen INT,OUT r_id_producto INT, OUT r_nombre t_nombre, OUT r_cantidad INT)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT productos_bodegas.id_producto, productos.nombre, productos_bodegas.cantidad_producto from
		inventario.productos_bodegas
		inner join
		inventario.productos
		on productos.id = productos_bodegas.id_producto and productos_bodegas.id_bodega = id_almacen;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION historial.mg_get_facturas(OUT r_id INT, OUT r_cedula t_cedula, OUT r_detalle t_descripcion, OUT r_tipo_pago t_tipo_pago, OUT r_fecha DATE, OUT r_tipo BOOLEAN, OUT r_total NUMERIC)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT id,cedula, detalle,tipo_pago, fecha, tipo, total::NUMERIC from historial.facturas;
END;
$body$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION historial.mg_get_productos_factura(IN e_id_factura INT,OUT r_id_factura INT, OUT r_id INT, OUT r_nombre t_nombre,
							     OUT r_precio NUMERIC, OUT r_cantidad INT, OUT r_precio_parcial NUMERIC)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT productos_facturas.id_factura,productos.id,productos.nombre, productos.precio::NUMERIC, productos_facturas.cantidad, productos_facturas.precio_parcial::NUMERIC from
		inventario.productos
		inner join
		historial.productos_facturas
		on productos_facturas.id_producto = productos.id and productos_facturas.id_factura = e_id_factura;
END;
$body$
LANGUAGE plpgsql;



-------------------------------------------------------------------- Lo de arriba funciona ------------------------------------------------------------------



CREATE OR REPLACE FUNCTION historial.mg_get_envios(IN e_id_factura INT,OUT r_id INT, OUT r_id_factura INT, OUT r_nombre t_nombre,OUT r_precio NUMERIC, OUT r_cantidad INT, OUT r_precio_parcial NUMERIC)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT productos_facturas.id_factura,productos.id,productos.nombre, productos.precio::NUMERIC, productos_facturas.cantidad, productos_facturas.precio_parcial::NUMERIC from
		inventario.productos
		inner join
		historial.productos_facturas
		on productos_facturas.id_producto = productos.id and productos_facturas.id_factura = e_id_factura;
END;
$body$
LANGUAGE plpgsql;


select * from historial.envios
select * from informacion.persona_tipo where tipo = 'E'
select * from historial.facturas
select * from inventario.camiones

select historial.insertar_envio(1,'1-0000-1111','NDR-123','1-2-2011')

select * from 
	historial.envios 
	inner join 
	informacion.personas
	on envios.cedula = personas.cedula

