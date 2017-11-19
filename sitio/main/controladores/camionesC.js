angular.module('moduloAdministrador')
    .controller('CtrlCamiones',
        function ($scope, $location, Conexion)
        {
            $scope.camiones;
            $scope.id_camion_edicion;

            $scope.cargarCamiones = function()
            {
                Conexion.getDatos(function (datos) {console.log(datos); $scope.camiones = datos;},"get_camiones", "");
            };

            $scope.cargarCamion  = function (numero)
            {
                $scope.id_camion_edicion = $scope.camiones[numero].r_placa;
                document.getElementById("id11").value =  $scope.camiones[numero].r_placa;
                document.getElementById("id22").value = $scope.camiones[numero].r_capacidad;
                document.getElementById("id33").value =  $scope.camiones[numero].r_descripcion;
                document.getElementById("id55").value = $scope.camiones[numero].r_combustible;
                $("#modal_editar_camion").modal("show");
            };



            $scope.guardar_camion_editado = function ()
            {
                var datos = document.getElementsByName("informacion_editada");
                var parametros = "?placa1=" + $scope.id_camion_edicion+"&placa2="+datos[0].value+"&capacidad="+datos[1].value +
                    "&descripcion="+datos[2].value + "&combustible="+datos[3].value;
                console.log(parametros);
                Conexion.agregarDatos("editar_camion", parametros, null);
                location.reload();
            };

            $scope.guardar_nuevo_camion = function ()
            {
                var datos = document.getElementsByName("informacion_nueva");

                var parametros = "?placa="+datos[0].value + "&capacidad="+datos[1].value +
                                 "&descripcion="+datos[2].value+"&combustible="+datos[3].value;
                console.log(parametros);
                Conexion.agregarDatos("agregar_camion", parametros, null);
                location.reload();
            };

            $scope.eliminar_camion = function (numero)
            {
                var id = $scope.camiones[numero].r_placa;
                var eliminar= confirm("¿Deseas eliminar este camion?");
                if(eliminar)
                {
                    Conexion.eliminarDatos("eliminar_camion", "?id="+id);
                    location.reload();
                }
            };
            $scope.cargarCamiones();
        });