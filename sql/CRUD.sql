
-- Provincias
CREATE OR REPLACE FUNCTION informacion.insertar_provincia(e_nombre t_nombre)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.provincias(nombre) VALUES (e_nombre);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_provincia(e_id int, e_nombre t_nombre)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.provincias SET nombre = e_nombre WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_provincia(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.provincias WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

-- Cantones
CREATE OR REPLACE FUNCTION informacion.insertar_canton(e_nombre t_nombre, e_id_provincia int )
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.cantones(nombre, id_provincia) VALUES (e_nombre, e_id_provincia);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_canton(e_id int , e_nombre t_nombre, e_id_provincia int)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.cantones SET (nombre, id_provincia) = (e_nombre, e_id_provincia) WHERE id=e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_canton(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.cantones WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;



-- Personas
CREATE OR REPLACE FUNCTION informacion.insertar_persona(cedula t_cedula, nombre t_nombre, apellido1 t_nombre, apellido2 t_nombre, genero boolean)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.personas VALUES (cedula, nombre, apellido1, apellido2, genero);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_persona(o_ced t_cedula, ced t_cedula, n_nombre t_nombre, n_apellido1 t_nombre, n_apellido2 t_nombre, n_genero boolean)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.personas
	SET (cedula, nombre, apellido1, apellido2, genero) = (ced,n_nombre, n_apellido1, n_apellido2,n_genero) WHERE cedula = o_ced;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION informacion.eliminar_persona(e_cedula t_cedula, e_tipo t_tipo)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.personas_tipo WHERE cedula = e_cedula and tipo = e_tipo;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


-- Familias
CREATE OR REPLACE FUNCTION inventario.insertar_familia(e_nombre t_nombre,e_tipo_almacen t_nombre, e_descripcion t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.familias(nombre, tipo_almacen, descripcion) VALUES (e_nombre, e_tipo_almacen, e_descripcion);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.modificar_familia(e_id int, n_nombre t_nombre,n_tipo_almacen t_nombre, n_descripcion t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.familias
	SET (nombre, tipo_almacen,descripcion) = (n_nombre, n_tipo_almacen, n_descripcion) WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.eliminar_familia(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.familias WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


-- Camiones
CREATE OR REPLACE FUNCTION inventario.insertar_camion(placa t_placa, capacidad int , descripcion t_descripcion, tipo_combustible varchar(10))
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.camiones VALUES (placa,capacidad, descripcion, tipo_combustible);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.modificar_camion(o_placa t_placa, n_placa t_placa, n_capacidad int, n_descripcion t_descripcion, n_tipo_combustible varchar(10))
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.camiones
	SET (placa,capacidad,descripcion, tipo_combustible) = (n_placa, n_capacidad, n_descripcion, n_tipo_combustible) WHERE placa = o_placa;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.eliminar_camion(e_placa t_placa)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.camiones WHERE placa= e_placa;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


-- telefonos

CREATE OR REPLACE FUNCTION informacion.insertar_telefono(e_cedula t_cedula, e_telefono t_telefono, e_tipo boolean)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.telefonos VALUES (e_cedula, e_telefono, e_tipo);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_telefono(e_cedula t_cedula,o_numero t_telefono, e_numero t_telefono, e_tipo boolean)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.telefonos SET (numero, tipo)=(e_numero, e_tipo) WHERE numero = o_numero AND cedula = e_cedula;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
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
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


-- Correos
CREATE OR REPLACE FUNCTION informacion.insertar_correo(e_cedula t_cedula, e_correo t_correo)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.correos VALUES  (e_cedula, e_correo);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_correo(e_cedula t_cedula, e_correo_anterior t_correo, e_correo_nuevo t_correo)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.correos SET (correo)= (e_correo_nuevo) WHERE cedula = e_cedula and e_correo_anterior=correo;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_correo(e_cedula t_cedula, e_correo t_correo)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.correos WHERE cedula = e_cedula AND correo=e_correo;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;




-- Contraseñas

CREATE OR REPLACE FUNCTION informacion.insertar_informacion_usuario(e_cedula t_cedula, e_password varchar)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.informacion_usuarios VALUES (e_cedula, md5(e_password || e_cedula ||'azZA'));
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_informacion_usuario(e_cedula t_cedula, e_password varchar, e_n_password varchar)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.informacion_usuarios SET (lg_info) = (md5(e_n_password || e_cedula ||'azZA')) WHERE lg_info = md5(e_password || e_cedula ||'azZA');
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION informacion.eliminar_informacion_usuario(e_cedula t_cedula, e_password varchar)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.informacion_usuarios WHERE lg_info = md5(e_password || e_cedula ||'azZA');
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

-- Facturas

CREATE OR REPLACE FUNCTION historial.insertar_factura(e_cedula t_cedula,e_detalle t_descripcion, e_tipo_pago t_tipo_pago, e_fecha date, e_tipo boolean, e_total numeric)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO historial.facturas(cedula, detalle, tipo_pago, fecha, tipo, total) VALUES (e_cedula,e_detalle, de_tipo_pago, e_fecha, e_tipo, e_total);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE
FUNCTION historial.modificar_factura(id_factura int , e_cedula t_cedula,e_detalle t_descripcion, e_tipo_pago t_tipo_pago, e_fecha date, e_tipo boolean, e_total numeric)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE historial.facturas SET (id,cedula,detalle, tipo_pago,fecha, tipo,total)=(id_factura, e_detalle, e_cedula, e_tipo_pago, e_fecha, e_tipo,e_total) WHERE id = id_factura;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.eliminar_factura(id_factura int )
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM historial.facturas WHERE id = id_factura;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION inventario.insertar_producto(e_nombre t_nombre, e_precio numeric , e_descripcion t_descripcion, e_id_familia int)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.productos (nombre, precio, descripcion, id_familia) VALUES (e_nombre, e_precio, e_descripcion, e_id_familia);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.modificar_producto(e_id int, e_nombre t_nombre, e_precio numeric , e_descripcion t_descripcion, e_id_familia int )
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.productos SET (nombre, precio, descripcion, id_familia) =(e_nombre, e_precio, e_descripcion, e_id_familia) WHERE id=e_id ;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inventario.eliminar_producto(e_id int )
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.productos WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION informacion.insertar_distrito(e_id_canton int,e_nombre t_nombre)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.distritos(nombre, id_canton) VALUES (e_nombre, e_id_canton);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_distrito(e_id int ,e_nombre t_nombre, e_id_canton int)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.distritos SET (nombre, id_canton) = (e_nombre, e_id_canton) WHERE id= e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_distrito(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.distritos WHERE id= e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;






CREATE OR REPLACE FUNCTION informacion.insertar_direccion( e_id_distrito int ,e_cedula t_cedula, e_direccion t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.direcciones(id_distrito,cedula,direccion_exacta) VALUES (e_id_distrito,e_cedula,e_direccion);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.modificar_direccion(e_id int ,e_id_distrito int, e_cedula t_cedula, e_direccion t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE informacion.direcciones SET (id_distrito, cedula, direccion_exacta)=(e_id_distrito, e_cedula, e_direccion) WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
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



CREATE OR REPLACE FUNCTION inventario.insertar_bodega(e_nombre t_nombre, e_tipo_almacen varchar, e_capacidad int, e_id_distrito int, e_direccion_exacta t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.bodegas (nombre, tipo_almacen, capacidad, id_distrito, direccion_exacta)
	VALUES(e_nombre, e_tipo_almacen, e_capacidad, e_id_distrito, e_direccion_exacta);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.modificar_bodega(e_id int, e_nombre t_nombre, e_tipo_almacen varchar, e_capacidad int, e_id_distrito int, e_direccion_exacta t_descripcion)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.bodegas
	SET (nombre, tipo_almacen, capacidad, id_distrito, direccion_exacta)=(e_nombre, e_tipo_almacen, e_capacidad, e_id_distrito, e_direccion_exacta) WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.eliminar_bodega(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM inventario.bodegas WHERE id = e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION inventario.insertar_producto_bodega(e_id_bodega int, e_id_producto int, e_cantidad int )
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO inventario.productos_bodegas VALUES (e_id_bodega, e_id_producto, e_cantidad);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inventario.modificar_producto_bodega(e_id_bodega int, e_id_producto int, e_cantidad int)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE inventario.productos_bodegas SET (cantidad_producto)=(e_cantidad) WHERE id_bodega = e_id_bodega AND id_producto = e_id_producto;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
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
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION historial.insertar_envio(e_id_factura int, e_cedula t_cedula, e_placa t_placa, e_fecha date )
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO historial.envios(id_factura, cedula, placa, fecha) VALUES (e_id_factura, e_cedula, e_placa, e_fecha);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
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
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial.eliminar_envio(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM historial.envios WHERE id=e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION informacion.insertar_persona_tipo(e_cedula t_cedula, e_tipo t_tipo)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO informacion.persona_tipo (cedula, tipo) VALUES (e_cedula, e_tipo);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION informacion.eliminar_persona_tipo(e_id int)
RETURNS BOOLEAN AS
$body$
BEGIN
	DELETE FROM informacion.persona_tipo WHERE id=e_id;
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;








CREATE OR REPLACE FUNCTION historial.insertar_producto_factura(id_factura int , id_producto int, cantidad_producto int, precio numeric)
RETURNS BOOLEAN AS
$body$
BEGIN
 -- Aqui falta la parte de actualizar factura
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

























------------------------------------  mas funciones ---------------------------------------------



-- Verifica contraseñas

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


-- Retorna las personas de un determinado tipo

CREATE OR REPLACE FUNCTION informacion.mg_get_personas_tipo(IN e_tipo t_tipo, OUT r_cedula t_cedula, OUT r_nombre t_nombre, OUT r_apellido1 t_nombre, OUT r_apellido2 t_nombre, OUT r_genero t_genero)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT cedula, nombre, apellido1, apellido2, genero FROM informacion.personas where tipo = e_tipo;
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





-- Permite obtener todos los camiones

CREATE OR REPLACE FUNCTION inventario.mg_get_camiones(OUT r_placa t_placa, OUT r_capacidad INT,OUT r_descripcion t_descripcion,OUT r_combustible varchar(10))
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT * from inventario.camiones;

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


-- Permite obtener la informacion acerca de las facturas

CREATE OR REPLACE FUNCTION historial.mg_get_facturas(OUT r_id INT, OUT r_cedula t_cedula, OUT r_tipo_pago t_tipo_pago, OUT r_fecha DATE, OUT r_tipo BOOLEAN, OUT r_total NUMERIC)
RETURNS
SETOF RECORD AS
$body$
BEGIN
	RETURN query SELECT id, cedula, tipo_pago, fecha, tipo, total::NUMERIC from historial.facturas;
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

-- Permite obtener la informacion de los productos de una factura.
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







