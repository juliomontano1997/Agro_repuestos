angular.module('moduloAdministrador')
    .controller('CtrlProductos', function ($scope, $location, ObjetosHtml, Conexion)
{
    $scope.mostrarProductos = function ()  // Muestra la lista de empleados actuales
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Codigo", "Nombre", "Precio", 'Familia', "Descripcion"]);
    };

    $scope.agregarProductosForm = function ()
    {
        document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Codigo producto", "cdp1", "Escriba el codigo") +
                ObjetosHtml.getEntradaTexto("Nombre del producto", "ndp1", "Escriba el nombre del producto") +
                ObjetosHtml.getEntradaTexto("Precio del producto", "pdp", "Escriba el precio del producto") +
                ObjetosHtml.getEntradaTexto("Coodigo de la famila", "cdf", "Escriba el codigo de la familia") +
                ObjetosHtml.getTextArea("Escriba la descripcion", "ddp");

        var boton = ObjetosHtml.getButton("Guardar");
        boton.addEventListener("click", function (e) {
            console.log("Guardando Producto");
        });
        document.getElementById("contenido").appendChild(boton);
    };
    $scope.eliminarProducto = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Codigo", "Nombre", "Precio", 'Familia', "Descripcion"]);
        document.getElementById("contenido").innerHTML +=
                ObjetosHtml.getEntradaTexto("Codigo del producto", "cdp1", "Escriba el codigo");

        var boton = ObjetosHtml.getButton("Eliminar");
        boton.addEventListener("click", function (e) {
            console.log("Eliminando Producto");
        });
        document.getElementById("contenido").appendChild(boton);
    };

    $scope.editarProducto = function ()
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Codigo", "Nombre", "Precio", 'Familia', "Descripcion"]);
        document.getElementById("contenido").innerHTML +=
                ObjetosHtml.getEntradaTexto("Codigo producto", "cdp1", "Escriba el codigo");
        var boton = ObjetosHtml.getButton("Editar");
        boton.addEventListener("click", function (e) {
            if (true) // se tiene  que verificar que el codigo existe
            {
                document.getElementById("contenido").innerHTML =
                        ObjetosHtml.getEntradaTexto("Codigo producto", "cdp1", "Escriba el codigo") +
                        ObjetosHtml.getEntradaTexto("Nombre del producto", "ndp1", "Escriba el nombre del producto") +
                        ObjetosHtml.getEntradaTexto("Precio del producto", "pdp", "Escriba el precio del producto") +
                        ObjetosHtml.getEntradaTexto("Coodigo de la famila", "cdf", "Esccriba el codigo de la familia") +
                        ObjetosHtml.getTextArea("Escriba la descripcion", "ddp");

                var boton = ObjetosHtml.getButton("Guardar");
                boton.addEventListener("click", function (e) {
                    console.log("Guardando Producto editado");
                });
                document.getElementById("contenido").appendChild(boton);
            } else 
            { 
            }
        });
        document.getElementById("contenido").appendChild(boton);
    };
    $scope.mostrarProductos();
});