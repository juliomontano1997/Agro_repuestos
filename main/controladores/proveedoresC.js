angular.module('moduloAdministrador')
    .controller('CtrlProveedores', function ($scope, $location, ObjetosHtml, Conexion)
    {
        $scope.variable=0;
        $scope.mostrarProveedores = function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["", "Cedula", "Nombre"]);
            var tabla = document.getElementById("tablaDatos");
            function  llenarTabla(datos)
            {
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    celda1.innerHTML = i + 1;
                    celda2.innerHTML =datos[i].cedula;
                    celda3.innerHTML  = datos[i].nombre + '  ' + datos[i].apellido1;
                }
            }
            Conexion.getDatos(llenarTabla, "proveedores");
        };


        $scope.NuevoRegistro = function ()
        {
            document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Cedula", "ced", "Escriba la cedula") +
                ObjetosHtml.getEntradaTexto("Nombre", "ndp", "Escriba el nombre") +
                ObjetosHtml.getEntradaTexto("Primer apellido", "ap1", "Escriba el primer apellido") +
                ObjetosHtml.getEntradaTexto("Segundo apellido", "ap2", "Escriba el segundo apellido") +
                ObjetosHtml.getRadio("Genero", ["Femenino", "Maculino"]);

            var boton = ObjetosHtml.getButton("Guardar");
            boton.addEventListener("click", function (e)
            {
                var ced = document.getElementById('ced').value;
                var n1 = document.getElementById('ndp').value;
                var a1 = document.getElementById('ap1').value;
                var a2 = document.getElementById('ap2').value;
                var gen=document.getElementsByName("gender")[0].checked;

                var datos = "?cedula="+ced+"&nombre="+n1+"&apellido1="+a1+"&apellido2="+a2+"&genero="+gen;
                Conexion.agregarDatos("agregarProveedor", datos);
            });
            document.getElementById("contenido").appendChild(boton);

            var boton2 = ObjetosHtml.getButton("Siguiente >>", "btn2");
            boton2.addEventListener("click", function (e)
            {
                $scope.variable = document.getElementById("ced").value;
                $scope.IntroducirDirecciones();
            });
            document.getElementById("contenido").appendChild(boton2);
        };




        $scope.IntroducirDirecciones= function ()
        {
            document.getElementById("contenido").innerHTML="";
            function cargarDirecciones(datos)
            {
                console.log(datos);
                var array1 = [];
                var array2 = [];
                var pos=0;
                for(pos=0; pos<datos.length; pos++)
                {
                    array1[pos] = datos[pos].direccion;
                    array2[pos] = datos[pos].iddistrito;
                    console.log(array1[pos]+array2[pos]);
                }
                document.getElementById("contenido").innerHTML += ObjetosHtml.getSelect2("Distritos:", array1, array2, "selectDistritos")+
                    ObjetosHtml.getEntradaTexto("Direccion exacta","diE", "Escriba la direccion exacta");

                var boton1 = ObjetosHtml.getButton("Guardar direccion", "btn1");
                boton1.addEventListener("click", function (e)
                {
                    var id = document.getElementById("selectDistritos").value;
                    var dir =  document.getElementById("diE").value;
                    var dt = '?ced='+$scope.variable+'&idd='+id+'&de='+dir;
                    console.log(dt);
                    Conexion.agregarDatos("agregarDireccionProveedor", dt);
                });
                document.getElementById("contenido").appendChild(boton1);



                var boton2 = ObjetosHtml.getButton("Siguiente >>", "btn2");
                boton2.addEventListener("click", function (e)
                {
                    $scope.insertarCorreos();
                });
                document.getElementById("contenido").appendChild(boton2);
            }
            Conexion.getDatos(cargarDirecciones, "direcciones");
        };

        $scope.insertarCorreos= function ()
        {
            document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Correos electronico:", 'email', 'ejemplo@gmail.com');
            var boton1 = ObjetosHtml.getButton("+ Añadir correo");
            boton1.addEventListener("click", function (e)
            {
                console.log(dt);
                var corr = document.getElementById("email").value;
                var dt = "?cedula="+$scope.variable+"&correo="+corr;
                console.log(dt);
                Conexion.agregarDatos("agregarCorreoProveedor", dt);
            });
            document.getElementById("contenido").appendChild(boton1);

            var boton2 = ObjetosHtml.getButton("Siguiente>>");
            boton2.addEventListener("click", function (e)
            {
                $scope.insertarTelefonos();
            });
            document.getElementById("contenido").appendChild(boton2);
        };

        $scope.insertarTelefonos= function ()
        {
            document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Numeros de telefonos:", 'tel', '0000-0000');
            var boton2 = ObjetosHtml.getButton("+ Añadir telefono");
            boton2.addEventListener("click", function (e)
            {
                var numero = document.getElementById("tel").value;
                var dt = "?cedula="+$scope.variable+"&telefono="+numero;
                console.log(dt);
                Conexion.agregarDatos("agregarTelefonoProveedor", dt);
            });
            document.getElementById("contenido").appendChild(boton2);
        };



        $scope.eliminarProveedor = function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["","Cedula", "Nombre", ""]);
            function  llenartabla(datos)
            {
                var tabla = document.getElementById("tablaDatos");
                for (i = 0; i < datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    var celda4 = fila.insertCell(3);
                    celda1.innerHTML = i + 1;
                    celda2.innerHTML = datos[i].cedula;
                    celda3.innerHTML = datos[i].nombre + '    ' + datos[i].apellido1 + " " + datos[i].apellido2;
                    var boton = ObjetosHtml.getButton("Eliminar proveedor");
                    boton.id = datos[i].cedula;
                    boton.addEventListener("click", function (e)
                    {
                        var eliminar=confirm("¿Deseas eliminar este proveedor?");
                        if(eliminar)
                        {
                            Conexion.eliminarDatos("eliminarProveedor", "?ced="+this.id);
                        }
                    });
                    celda4.appendChild(boton);
                }
            }
            Conexion.getDatos(llenartabla, "proveedores");};
        $scope.mostrarProveedores();
    });