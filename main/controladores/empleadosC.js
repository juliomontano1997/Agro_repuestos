angular.module('moduloAdministrador')
    .controller('CtrlEmpleados', function ($scope, $location,$http,  ObjetosHtml, Conexion)
    {


        $scope.informacionEmpleados=0;
        $scope.informacion=0;
        $scope.registroEmpleados = function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Numero", "Cedula", "Nombre"]);
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
            Conexion.getDatos(llenarTabla, "empleados");
        };

        $scope.NuevoRegistro = function ()
        {
            document.getElementById("contenido").innerHTML ='<form">'+
                ObjetosHtml.getEntradaTexto("Numero de identificacion:", 'ced', '0-0000-0000') +
                ObjetosHtml.getEntradaTexto("Nombre:", "n1", "Nombre") +
                ObjetosHtml.getEntradaTexto("Primer Apellido:", 'a1', 'Primer apellido') +
                ObjetosHtml.getEntradaTexto("Segundo Apellido:", 'a2', 'Segundo apellido') +
                ObjetosHtml.getSelect("Estado civil:", ["Soltero(a)", "Viudo(a)", "Divorciado(a)", "Casado(a)", "Union libre"], "EC") +
                ObjetosHtml.getRadio("Genero:", ["Femenino", "Maculino"]) +
                ObjetosHtml.getEntradaTexto("Salario por hora:", 'sal', '00000') +
                ObjetosHtml.getTextArea("Hoja de delincuencia:", "hd") +'</form>';



            var boton1 = ObjetosHtml.getButton("Registrar", "btn1");
            boton1.addEventListener("click", function (e)
            {
                var ced = document.getElementById('ced').value;
                var n1 = document.getElementById('n1').value;
                var a1 = document.getElementById('a1').value;
                var a2 = document.getElementById('a2').value;
                var sal = document.getElementById('sal').value;
                var hd= document.getElementById('hd').value;
                var ec= document.getElementById('EC').value;
                var gen=document.getElementsByName("gender")[0].checked;
                var datos = "?cedula="+ced+"&nombre="+n1+"&apellido1="+a1+"&apellido2="+a2+"&genero="+gen+"&estadoCivil="+ec[0]+"&salario="+sal+"&hojaDelincuencia="+hd;
                Conexion.agregarDatos("agregarEmpleado", datos);
            });
            document.getElementById("contenido").appendChild(boton1);



            var boton2 = ObjetosHtml.getButton("Siguiente >>", "btn2");
            boton2.addEventListener("click", function (e)
            {
                $scope.informacionEmpleados = document.getElementById("ced").value;
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
                    var dt = '?ced='+$scope.informacionEmpleados+'&idd='+id+'&de='+dir;
                    console.log(dt);
                    Conexion.agregarDatos("agregarDireccionEmpleado", dt);
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
                var dt = "?cedula="+$scope.informacionEmpleados+"&correo="+corr;
                console.log(dt);
                Conexion.agregarDatos("agregarCorreoEmpleado", dt);
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
                var dt = "?cedula="+$scope.informacionEmpleados+"&telefono="+numero;
                console.log(dt);
                Conexion.agregarDatos("agregarTelefonoEmpleado", dt);
            });
            document.getElementById("contenido").appendChild(boton2);

            var boton3 = ObjetosHtml.getButton("Siguiente>>");
            boton3.addEventListener("click", function (e)
            {
                $scope.insertarCurriculum();
            });
            document.getElementById("contenido").appendChild(boton3);
        };

        $scope.insertarCurriculum = function ()
        {
            document.getElementById("contenido").innerHTML =
                ObjetosHtml.getTextArea("Estudios:", "est");
            var boton1 = ObjetosHtml.getButton("Guardar curriculum");
            boton1.addEventListener("click", function (e)
            {
                var est = document.getElementById("est").value;
                var dt = "?cedula="+$scope.informacionEmpleados+"&estudios="+est;
                console.log(dt);
                Conexion.agregarDatos("agregarCurriculum", dt);
            });
            document.getElementById("contenido").appendChild(boton1);

            var boton2 = ObjetosHtml.getButton("Siguiente>>");
            boton2.addEventListener("click", function (e)
            {
                $scope.insertarRecomendaciones();
            });
            document.getElementById("contenido").appendChild(boton2);
        };

        $scope.insertarRecomendaciones = function ()
        {
            function  realizartrasaccion(idCurriculum)
            {
                $scope.informacion=idCurriculum[0].idcurriculum;

                document.getElementById("contenido").innerHTML = ObjetosHtml.getTextArea("Carta","crt" )+ObjetosHtml.getEntradaTexto("Enviante", "env");
                var boton1 = ObjetosHtml.getButton("Guardar carta");
                boton1.addEventListener("click", function (e)
                {
                    var car = document.getElementById("crt").value;
                    var env = document.getElementById("env").value;
                    var dt = "?idC="+$scope.informacion+"&carta="+car+"&env="+env;
                    console.log(dt);
                    Conexion.agregarDatos("agregarRecomendaciones",dt);
                });
                document.getElementById("contenido").appendChild(boton1);
                var boton2 = ObjetosHtml.getButton("Siguiente>>");
                boton2.addEventListener("click", function (e)
                {
                    $scope.insertarExperiencias();
                });
                document.getElementById("contenido").appendChild(boton2);
            }
            console.log($scope.informacionEmpleadoss);
            Conexion.getDatos(realizartrasaccion, "getIdCurriculum", "?ced="+$scope.informacionEmpleados)
        };
        $scope.insertarExperiencias = function ()
        {

            document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Nombre empreza","NE" )+
                ObjetosHtml.getEntradaTexto("duracion", "dur")+
                ObjetosHtml.getEntradaTexto("Puesto", "pst");

            var boton1 = ObjetosHtml.getButton("Guardar experiencia laboral");
            boton1.addEventListener("click", function (e)
            {
                var nE = document.getElementById("NE").value;
                var dur = document.getElementById("dur").value;
                var pst = document.getElementById("pst").value;
                var dt = "?idC="+$scope.informacion+"&empresa="+nE+"&tiempo="+dur+"&puesto="+pst;
                Conexion.agregarDatos("agregarExperienciasLaboral",dt);
            });
            document.getElementById("contenido").appendChild(boton1);
        };

        $scope.borrarEmpleadoForm = function () // Carga el formulario de borrado de empleado
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
                    var boton = ObjetosHtml.getButton("Eliminar");
                    boton.id = datos[i].cedula;
                    boton.addEventListener("click", function (e)
                    {
                        var eliminar=confirm("¿Deseas eliminar este empleado?");
                        if(eliminar)
                        {
                            Conexion.eliminarDatos("eliminarEmpleado", "?ced="+this.id);
                        }
                    });
                    celda4.appendChild(boton);
                }
            }
            Conexion.getDatos(llenartabla, "empleados");
        };

        $scope.registroEmpleados();
    });