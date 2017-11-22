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
CREATE OR REPLACE FUNCTION informacion.insertar_persona(
ced t_cedula, nombre t_nombre, apellido1 t_nombre, apellido2 t_nombre, genero boolean, tipo_persona t_tipo)
RETURNS BOOLEAN AS
$body$
BEGIN
	IF (SELECT count(cedula) from informacion.personas where cedula = ced)= 0 THEN 
		INSERT INTO informacion.personas VALUES (ced, nombre, apellido1, apellido2, genero);
		INSERT INTO informacion.persona_tipo values(ced,tipo_persona);
		RETURN TRUE;
	ELSE 
		IF (select count(cedula) from informacion.persona_tipo where cedula=ced and tipo = tipo_persona)=0 THEN
			INSERT INTO informacion.persona_tipo values (ced, tipo_persona);
			RETURN TRUE;
		ELSE 
			RETURN FALSE;	
		END IF;
	END IF;
		
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
	DELETE FROM informacion.persona_tipo WHERE cedula = e_cedula and tipo = e_tipo;
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
	SET (nombre, tipo_almacen, descripcion) = (n_nombre, n_tipo_almacen, n_descripcion) WHERE id = e_id;
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

CREATE OR REPLACE FUNCTION historial.insertar_factura(e_cedula t_cedula,e_detalle t_descripcion, e_tipo_pago t_tipo_pago, e_fecha date, e_tipo boolean)
RETURNS BOOLEAN AS
$body$
BEGIN
	INSERT INTO historial.facturas(cedula, detalle, tipo_pago, fecha, tipo) VALUES (e_cedula,e_detalle,e_tipo_pago, e_fecha, e_tipo);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN RETURN FALSE;
END;
$body$
LANGUAGE plpgsql;


CREATE OR REPLACE
FUNCTION historial.modificar_factura(id_factura int , e_cedula t_cedula,e_detalle t_descripcion, e_tipo_pago t_tipo_pago, e_fecha date, e_tipo boolean)
RETURNS BOOLEAN AS
$body$
BEGIN
	UPDATE historial.facturas SET (id,cedula,detalle, tipo_pago,fecha, tipo)=(id_factura, e_detalle, e_cedula, e_tipo_pago, e_fecha, e_tipo) WHERE id = id_factura;
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
	IF(SELECT count(id_producto) from inventario.productos_bodegas where id_producto=e_id_producto and id_bodega = e_id_bodega)=1 THEN
		UPDATE inventario.productos_bodegas set (cantidad_producto)=(cantidad_producto+e_cantidad)  WHERE id_bodega = e_id_bodega AND id_producto = e_id_producto;
		RETURN TRUE;
	ELSE 		
		INSERT INTO inventario.productos_bodegas VALUES (e_id_bodega, e_id_producto, e_cantidad);
		RETURN TRUE;
	END IF; 
	
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
	-- Aqui falta la parte de actualizar factura
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