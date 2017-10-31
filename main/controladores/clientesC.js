angular.module('moduloAdministrador')
.controller('CtrlClientes', function ($scope, $location, ObjetosHtml, Conexion)
{
    $scope.mostrarClientes = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Direccion"]);
        // Aqui se rellena la tabla    
    };

    $scope.nuevoCliente = function ()
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
            console.log("Guardando cliente");
        });
        document.getElementById("contenido").appendChild(boton);

    };

    $scope.editarClientes = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Direccion"]);
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
                console.log("Guardando cambios en  cliente");
            });
            document.getElementById("contenido").appendChild(boton);

        });
        document.getElementById("contenido").appendChild(boton);


    };

    $scope.consultarCliente = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Direccion"]);

        document.getElementById("contenido").innerHTML += ObjetosHtml.getEntradaTexto("Cedula del cliente a consultar:", "ced", "Escriba la cedula");

        var boton = ObjetosHtml.getButton("Consultar");
        boton.addEventListener("click", function (e)
        {
            console.log("Consultando Cliente");
        });

        document.getElementById("contenido").appendChild(boton);
    };



    $scope.eliminarCliente = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Direccion"]);
        document.getElementById("contenido").innerHTML += ObjetosHtml.getEntradaTexto("Cedula", "ced", "Escriba la cedula");

        var boton = ObjetosHtml.getButton("Eliminar");
        boton.addEventListener("click", function (e)
        {
            console.log("Eliminando cliente");
        });
        document.getElementById("contenido").appendChild(boton);
    };
    $scope.mostrarClientes();
});