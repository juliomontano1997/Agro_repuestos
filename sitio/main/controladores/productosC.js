angular.module('moduloAdministrador')
    .controller('CtrlProductos', function ($scope, $location, Conexion)
    {
        $scope.bodegas;
        $scope.familias;
        $scope.productos;
        $scope.id_edicion;

        $scope.cargarProductos= function()
        {
            Conexion.getDatos(function (datos){$scope.productos=datos;}, "get_productos", "");
            Conexion.getDatos(function (datos) { $scope.familias = datos;}, "get_familias", "");
        };

        $scope.selFamilia = function (id_buscado)
        {
            var maximo = $scope.familias.length;
            for(i=0; i<maximo; i++)
            {
                if(id_buscado===$scope.familias[i].r_id)
                {
                    return i;
                }
            }
            return 0;
        };


        $scope.cargarProducto = function (indice)
        {
            var datos =$scope.productos[indice];
            $scope.id_edicion = datos.r_id;
            document.getElementById("e_nombre").value = datos.r_nombre;
            document.getElementById("e_precio").value = datos.r_precio;
            document.getElementById("e_descripcion").value = datos.r_descripcion;
            document.getElementById("e4").selectedIndex= $scope.selFamilia(datos.r_id_familia);
            $("#modal_modificar_producto").modal("show");
        };

        $scope.eliminarProducto = function (indice)
        {
            var id= $scope.productos[indice].r_id;
            var eliminar= confirm("¿Deseas eliminar este producto?");
            if(eliminar)
            {
                Conexion.eliminarDatos("eliminar_producto","?id="+id);
                location.reload();
            }
        };

        $scope.agregarProducto = function ()
        {
            var datos = document.getElementsByName("informacion_nueva");
            var id_familia = $scope.familias[document.getElementById("id4").selectedIndex].r_id;
            var parametros  = "?nombre="+datos[0].value + "&precio="+datos[1].value+"&descripcion="+datos[2].value+"&id_familia="+id_familia;
            Conexion.agregarDatos("agregar_producto", parametros, null);
            location.reload();
        };

        $scope.modificarProducto = function ()
        {
            var datos = document.getElementsByName("informacion_editada");
            var id_familia = $scope.familias[document.getElementById("e4").selectedIndex].r_id;

            var parametros  = "?nombre="+datos[0].value + "&precio="+datos[1].value+
                "&descripcion="+datos[2].value+"&id_familia="+id_familia+"&id="+$scope.id_edicion;
            Conexion.agregarDatos("editar_producto", parametros, null);
            location.reload();
        };

        $scope.cargarProductos();
    });