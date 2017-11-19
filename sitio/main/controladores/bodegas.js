angular.module('moduloAdministrador')
    .controller('CtrlBodegas',
        function ($scope, $location, Conexion)
        {
            $scope.bodegas;
            $scope.id_bodega_edicion;
            $scope.distritos;
            $scope.productosEnBodega;
            $scope.productos;

            $scope.selDistrito = function (id_buscado)
            {
                var maximo = $scope.distritos.length;
                for(i=0; i<maximo; i++)
                {
                    if(id_buscado===$scope.distritos[i].r_id)
                    {
                        return i;
                    }
                }
                return 0;
            };

            $scope.cargarBodegas = function()
            {
                Conexion.getDatos(function (datos) {console.log(datos); $scope.bodegas = datos;},"get_bodegas", "");
                Conexion.getDatos(function (datos) {console.log(datos); $scope.distritos = datos;},"get_distritos", "");
            };

            $scope.cargarBodega  = function (numero){
                $scope.id_bodega_edicion = $scope.bodegas[numero].r_id;
                document.getElementById("id11").value =  $scope.bodegas[numero].r_nombre;
                document.getElementById("id22").value = $scope.bodegas[numero].r_tipo_almacen;
                document.getElementById("id33").value =  $scope.bodegas[numero].r_capacidad;
                document.getElementById("id44").selectedIndex= $scope.selDistrito( $scope.bodegas[numero].r_id_distrito);
                document.getElementById("id55").value = $scope.bodegas[numero].r_direccion_exacta;
                Conexion.getDatos(function (datos) {console.log(datos); $scope.productos = datos;},"get_productos", "");
                $("#modal_editar_bodega").modal("show");
            };

            $scope.guardar_nueva_Bodega = function ()
            {
                var datos = document.getElementsByName("informacion_nueva");
                var id_distrito = $scope.distritos[document.getElementById("id4").selectedIndex].r_id;
                var parametros = "?nombre="+datos[0].value +
                    "&tipo="+datos[1].value + "&capacidad="+datos[2].value+"&id_distrito="+id_distrito+"&direccion="+datos[3].value;
                console.log(parametros);
                Conexion.agregarDatos("agregar_bodega", parametros, null);
                location.reload();
            };


            $scope.guardar_bodega_editada = function ()
            {
                var datos = document.getElementsByName("informacion_editada");
                console.log(datos);
                var id_distrito = $scope.distritos[document.getElementById("id44").selectedIndex].r_id;
                var parametros ="?id=" + $scope.id_bodega_edicion+"&nombre="+datos[0].value +
                    "&tipo="+datos[1].value + "&capacidad="+datos[2].value+"&id_distrito="+id_distrito+"&direccion="+datos[3].value;
                console.log(parametros);
                Conexion.agregarDatos("editar_bodega", parametros, null);
                location.reload();
            };

            $scope.guardarProductoEnBodega = function ()
            {
                var id_producto = $scope.productos[document.getElementById("selectProducto").selectedIndex].r_id;
                var cantidad = document.getElementById("imput_cantidad").value;
                var parametros ="?id_producto=" +id_producto+"&id_bodega="+ $scope.id_bodega_edicion+"&cantidad="+cantidad;
                console.log(parametros);
                Conexion.agregarDatos("agregar_producto_bodega", parametros, null);
            };

            $scope.eliminar_bodega = function (numero)
            {
                var id = $scope.bodegas[numero].r_id;
                var eliminar= confirm("¿Deseas eliminar esta bodega?");
                if(eliminar)
                {
                    Conexion.eliminarDatos("eliminar_bodega", "?id="+id);
                    location.reload();
                }
            };

            $scope.cargarProductosBodega= function()
            {
                console.log()
                Conexion.getDatos(function (datos) {$scope.productosEnBodega=datos;}, "get_productos_bodega", "?id_bodega="+$scope.id_bodega_edicion);
                $("#modal_productos_bodega").modal("show");
            }
            $scope.cargarBodegas();
        });