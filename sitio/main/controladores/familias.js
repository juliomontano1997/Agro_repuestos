angular.module('moduloAdministrador')
.controller('CtrlFamilias',
function ($scope, $location, ObjetosHtml, Conexion)
{
    $scope.familias;
    $scope.familiaEdicion;

    $scope.cargarFamilias = function()
    {
        Conexion.getDatos(function (datos) {console.log(datos);$scope.familias =datos },"get_familias", "");
    };

    $scope.cargarFamilia = function (numero)
    {
        $scope.familiaEdicion = $scope.familias[numero].r_id;
        document.getElementById("n_nombre1").value = $scope.familias[numero].r_nombre;
        document.getElementById("n_tipo_almacen1").value = $scope.familias[numero].r_tipo_almacen;
        document.getElementById("descripcion1").value =$scope.familias[numero].r_descripcion;
        $("#modal_editar_familia").modal("show");
    };

    $scope.guardar_nueva_familia = function ()
    {
        var datos = document.getElementsByName("informacion_nueva");
        var parametros = "?nombre="+datos[0].value + "&tipo="+datos[1].value + "&descripcion="+datos[2].value;
        console.log(parametros);
        Conexion.agregarDatos("agregar_familia", parametros, null);
        location.reload();
    };


    $scope.guardar_familia_editada = function (s)
    {
        var datos = document.getElementsByName("informacion_editada");
        var parametros = "?nombre="+datos[0].value + "&tipo="+datos[1].value + "&descripcion="+datos[2].value+"&id="+$scope.familiaEdicion;
        console.log(parametros);
        Conexion.agregarDatos("editar_familia", parametros, null);
        location.reload();
    };

    $scope.eliminar_familia = function (numero)
    {
        var id = $scope.familias[numero].r_id;
        var eliminar= confirm("¿Deseas eliminar esta familia?");
        if(eliminar)
        {
            Conexion.eliminarDatos("eliminar_familia", "?id="+id);
            location.reload();
        }
    };
    $scope.cargarFamilias();
});