angular.module('moduloAdministrador')
    .controller('CtrlProductos', function ($scope, $location, ObjetosHtml, Conexion)
    {
        $scope.datosAux = 0;
        $scope.mostrarProductos = function ()  // Muestra la lista de empleados actuales
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Codigo", "Nombre", "Precio"]);
            var tabla = document.getElementById("tablaDatos");
            function  llenarTabla(datos)
            {
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    celda1.innerHTML = datos[i].codigoproducto;
                    celda2.innerHTML =datos[i].nombre;
                    celda3.innerHTML  = datos[i].precioactual;
                }
            }
            Conexion.getDatos(llenarTabla, "productos");
        };



        $scope.agregarProductosForm = function ()
        {
            function cargarDatos(info)
            {
                console.log(info);
                var array1 = [];
                var array2 = [];
                var pos=0;
                for(pos=0; pos<info.length; pos++)
                {
                    array1[pos] = info[pos].nombrefamilia;
                    array2[pos] = info[pos].codigofamilia;
                    console.log(array1[pos]+array2[pos]);
                }
                document.getElementById("contenido").innerHTML =
                    ObjetosHtml.getEntradaTexto("Nombre del producto", "ndp1", "Escriba el nombre del producto") +
                    ObjetosHtml.getEntradaTexto("Precio del producto", "pdp", "Escriba el precio del producto") +
                    ObjetosHtml.getSelect2("Familia:", array1, array2, "selectFamilias")+
                    ObjetosHtml.getTextArea("Escriba la descripcion", "ddp");

                var boton = ObjetosHtml.getButton("Guardar");
                boton.addEventListener("click", function (e)
                {
                    var nombre = document.getElementById('ndp1').value;
                    var precio = document.getElementById('pdp').value;
                    var codigoFam = document.getElementById('selectFamilias').value;
                    var descripcion = document.getElementById('ddp').value;
                    var dt = "?nombre="+nombre+"&precio="+precio+"&codigoFamilia="+codigoFam+"&descripcion="+descripcion;
                    Conexion.agregarDatos("agregarProducto", dt);
                });
                document.getElementById("contenido").appendChild(boton);

                /* var boton = ObjetosHtml.getButton("Siguiente>>");
                boton.addEventListener("click", function (e)
                {
                    $scope.datosAux = document.getElementById("");
                });
                document.getElementById("contenido").appendChild(boton); */
            };
            Conexion.getDatos(cargarDatos, "familias");
        };

        $scope.guardarEnBodega = function ()
        {
            document.getElementById("contenido").innerHTML =   ObjetosHtml.getEntradaTexto("Codigo producto", "cdp1", "Escriba el codigo");
        }


        $scope.eliminarProducto = function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Codigo", "Nombre", "Precio", 'Familia', "Descripcion", ""]);

            function  llenartabla(datos)
            {
                var tabla = document.getElementById("tablaDatos");
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    var celda4 = fila.insertCell(3);
                    var celda5 = fila.insertCell(4);
                    var celda6 = fila.insertCell(5);
                    celda1.innerHTML = datos[i].codigoproducto;
                    celda2.innerHTML =datos[i].nombre;
                    celda3.innerHTML  = datos[i].precioactual;
                    celda4.innerHTML  = datos[i].codigofamilia;
                    celda5.innerHTML  = datos[i].descripcion;

                    var boton = ObjetosHtml.getButton("Eliminar");
                    boton.id = datos[i].codigoproducto;
                    boton.addEventListener("click", function (e)
                    {
                        var eliminar=confirm("¿Deseas eliminar este producto?");
                        if(eliminar)
                        {
                            console.log(this.id);
                            Conexion.eliminarDatos("eliminarProducto", "?id="+this.id);
                        }
                    });
                    celda6.appendChild(boton);
                }
            }
            Conexion.getDatos(llenartabla, "productos");
        };

        $scope.mostrarProductos();
    });