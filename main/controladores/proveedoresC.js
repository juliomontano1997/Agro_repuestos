angular.module('moduloAdministrador')
.controller('CtrlProveedores', function ($scope, $location, ObjetosHtml, Conexion)
{
    $scope.mostrarProveedores = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Productos", "Direccion"]);
    };
    $scope.nuevoProvedor = function ()
    {
        document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Cedula", "ced", "Escriba la cedula") +
                ObjetosHtml.getEntradaTexto("Nombre", "ndp", "Escriba el nombre") +
                ObjetosHtml.getEntradaTexto("Primer apellido", "ap1", "Escriba el primer apellido") +
                ObjetosHtml.getEntradaTexto("Segundo apellido", "ap2", "Escriba el segundo apellido") +
                ObjetosHtml.getSelect("Genero", ["Femenino", "Maculino", "Otro"]);

        var boton = ObjetosHtml.getButton("Guardar");
        boton.addEventListener("click", function (e)
        {
            console.log("Guardando proveedor");
        });
        document.getElementById("contenido").appendChild(boton);

    };


    $scope.editarProveedor = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Productos", "Direccion"]);
        document.getElementById("contenido").innerHTML += ObjetosHtml.getEntradaTexto("Cedula", "ced", "Escriba la cedula");
        var boton = ObjetosHtml.getButton("Editar");
        boton.addEventListener("click", function (e)
        {
            document.getElementById("contenido").innerHTML =
                    ObjetosHtml.getEntradaTexto("Cedula", "ced", "Escriba la cedula") +
                    ObjetosHtml.getEntradaTexto("Nombre", "ndp", "Escriba el nombre") +
                    ObjetosHtml.getEntradaTexto("Primer apellido", "ap1", "Escriba el primer apellido") +
                    ObjetosHtml.getEntradaTexto("Segundo apellido", "ap2", "Escriba el segundo apellido") +
                    ObjetosHtml.getSelect("Genero", ["Femenino", "Maculino", "Otro"]);

            var boton = ObjetosHtml.getButton("Guardar cambios");
            boton.addEventListener("click", function (e)
            {
                console.log("Guardando cambios en  proveedor");
            });
            document.getElementById("contenido").appendChild(boton);

        });
        document.getElementById("contenido").appendChild(boton);
    };

    $scope.eliminarProveedor = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Productos", "Direccion"]);
        document.getElementById("contenido").innerHTML += ObjetosHtml.getEntradaTexto("Cedula", "ced", "Escriba la cedula");

        var boton = ObjetosHtml.getButton("Eliminar");
        boton.addEventListener("click", function (e)
        {
            console.log("Eliminando proveedor");
        });
        document.getElementById("contenido").appendChild(boton);
    };
    $scope.mostrarProveedores();
});