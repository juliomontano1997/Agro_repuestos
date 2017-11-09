angular.module('moduloAdministrador')
    .controller('CtrlEmpleados', function ($scope, $location,$http,  ObjetosHtml, Conexion)
    {

        $scope.empleados = [];
        $scope.cedula = '';
        $scope.nombre = '';
        $scope.primer_apellido = '';
        $scope.segundo_apellido = '';
        $scope.genero = '';


        $scope.mostrarEmpleados = function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Numero", "Cedula", "Nombre", ""], 'tablaDatos');
            var funcion = function(datos)
            {
                var tabla = document.getElementById("tablaDatos");
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0).innerHTML = String(i + 1);
                    var celda2 = fila.insertCell(1).innerHTML = datos[i].r_cedula;
                    var celda3 = fila.insertCell(2).innerHTML = datos[i].r_nombre + ' ' + datos[i].r_apellido1 +' ' + datos[i].r_apellido2;
                    var boton = ObjetosHtml.getButton("Ver/Editar");
                    boton.id = datos[i].r_cedula;
                    boton.addEventListener("click", function (e) {$scope.mostrarEmpleadoForm(this.id);});
                    fila.insertCell(3).appendChild(boton);
                }
            };
            Conexion.getDatos(funcion, "get_personas_tipo", '?tipo=E');
        };

        $scope.borrarEmpleadoForm = function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["","Cedula", "Nombre", ""], "tablaDatos");
            function  llenartabla(datos)
            {
                var tabla = document.getElementById("tablaDatos");
                for (i = 0; i < datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    fila.insertCell(0).innerHTML = String(i + 1);
                    fila.insertCell(1).innerHTML = datos[i].r_cedula;
                    fila.insertCell(2).innerHTML = datos[i].r_nombre + ' ' + datos[i].r_apellido1;
                    var boton = ObjetosHtml.getButton("Eliminar");
                    boton.id = datos[i].r_cedula;
                    boton.addEventListener("click", function (e)
                    {
                        var eliminar= confirm("¿Deseas eliminar este empleado y toda su informacion?");
                        if(eliminar)
                        {
                            // Falta agregar cascade a las cosas
                            Conexion.eliminarDatos("eliminar_persona", "?cedula="+this.id+'&telefono='+datos[i].r_numero);
                        }
                    });
                    fila.insertCell(3).appendChild(boton);
                }
            }
            Conexion.getDatos(llenartabla, "get_personas_tipo", '?tipo=E');
        };




//  -----------------------------   En proceso  ------------------------------------------
        $scope.mostrarEmpleadoForm = function (id_empleado)
        {
            document.getElementById("contenido").innerHTML="";

            document.getElementById("contenido").innerHTML=
                '<form id="form1">'+
                ObjetosHtml.getEntradaTexto("Numero de identificacion:", "id= 'ced'  placeholder='0-0000-0000' type='text'") +
                ObjetosHtml.getEntradaTexto("Nombre:", "id='n1' placeholder='Nombre' type='text'") +
                ObjetosHtml.getEntradaTexto("Primer Apellido:", "id='a1' placeholder='Primer apellido' type='text'") +
                ObjetosHtml.getEntradaTexto("Segundo Apellido:", "id='a2' placeholder='Segundo apellido' type='text'") +
                ObjetosHtml.getRadio("Genero:", ["Femenino", "Maculino"]) +
                '</form>';
            var funcion0 = function (datos)// sirve para llenar datos en la interfaz de edición
            {
                document.getElementById("ced").value=  id_empleado;
                document.getElementById("n1").value = datos[0].r_nombre;
                document.getElementById("a1").value = datos[0].r_apellido1;
                document.getElementById("a2").value = datos[0].r_apellido2;
                console.log(datos[0]);
                if(datos[0].r_genero===true) {document.getElementsByName("gender")[0].checked=true;}
                else {document.getElementsByName("gender")[1].checked=true;}
            };
            Conexion.getDatos(funcion0, "get_persona", '?cedula='+id_empleado);


            var boton_guardar = ObjetosHtml.getButton("Guardar", "btn1").addEventListener('click', function (e) {$scope.guardar_informacion_empleado();});
            document.getElementById("form1").appendChild(boton_guardar);


            document.getElementById("contenido").innerHTML += '<br>'+ ObjetosHtml.getEtiqueta('Telefonos') +
                ObjetosHtml.getTable(["Numero", "Tipo","", ""], "tablaTelefonos");



            var funcion1 = function(datos)
            {
                var tablatelefonos = document.getElementById("tablaTelefonos");
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tablatelefonos.insertRow();
                    fila.insertCell(0).innerHTML = datos[i].r_numero;
                    if(datos[i].r_tipo===true || datos[i].r_tipo ==="true") {fila.insertCell(1).innerHTML = "Celular";}
                    else {fila.insertCell(1).innerHTML = "Oficina";}
                    var boton1 = ObjetosHtml.getButton("Editar");
                    boton1.id = datos[i].r_cedula;
                    boton1.addEventListener("click", function (e)
                    {
                        // llama a un modal para edicion
                    });
                    var boton2 = ObjetosHtml.getButton("Eliminar");
                    boton2.id = datos[i].r_cedula;
                    boton2.addEventListener("click", function (e)
                    {
                        var eliminar= confirm("¿Deseas eliminar este numero?");
                        if(eliminar)
                        {
                            Conexion.eliminarDatos("eliminar_telefono", "?cedula="+this.id+'&telefono='+datos[i].r_numero);
                        }
                    });
                    fila.insertCell(2).appendChild(boton1);
                    fila.insertCell(3).appendChild(boton2);
                }
            };
            Conexion.getDatos(funcion1, "get_telefonos", '?cedula='+id_empleado);
            document.getElementById("contenido").innerHTML += ObjetosHtml.getEtiqueta('Correos');
            document.getElementById("contenido").innerHTML += ObjetosHtml.getTable(["","", ""], 'tablaCorreos');

            var funcion2 = function(datos)
            {
                var tablacorreos = document.getElementById("tablaCorreos");
                console.log(datos);
                for (i = 0; i < datos.length; i++)
                {
                    var fila = tablacorreos.insertRow();
                    fila.insertCell(0).innerHTML = datos[i].r_correo;
                    var boton1 = ObjetosHtml.getButton("Editar");
                    boton1.id = datos[i].r_cedula;
                    boton1.addEventListener("click", function (e)
                    {
                        // llama a un modal para edicion
                    });
                    var boton2 = ObjetosHtml.getButton("Eliminar");
                    boton2.id = datos[i].r_cedula;
                    boton2.addEventListener("click", function (e)
                    {
                        var eliminar= confirm("¿Deseas eliminar este correo?");
                        if(eliminar)
                        {
                            Conexion.eliminarDatos("eliminar_telefono", "?cedula="+this.id+'&correo='+datos[i].r_correo);
                        }
                    });
                    fila.insertCell(1).appendChild(boton1);
                    fila.insertCell(2).appendChild(boton2);
                }
            };
            Conexion.getDatos(funcion2, "get_correos", '?cedula='+id_empleado);
        };


        $scope.guardar_informacion_empleado = function()
        {
            console.log('Hola putos');
            var ced = id_empleado;
            var n1 = document.getElementById('n1').value;
            var a1 = document.getElementById('a1').value;
            var a2 = document.getElementById('a2').value;
            var gen=document.getElementsByName("gender")[0].checked;
            var datos = "?cedula="+ced+"&nombre="+n1+"&apellido1="+a1+"&apellido2="+a2+"&genero="+gen+"&tipo=E";
            //Conexion.agregarDatos("modificar_persona", datos);
        };















        $scope.NuevoRegistro = function ()
        {
            document.getElementById("contenido").innerHTML =
                '<form id="form1">'+
                    ObjetosHtml.getEntradaTexto("Numero de identificacion:", "id= 'ced'  placeholder='0-0000-0000' type='text'") +
                    ObjetosHtml.getEntradaTexto("Nombre:", "id='n1' placeholder='Nombre' type='text'") +
                    ObjetosHtml.getEntradaTexto("Primer Apellido:", "id='a1' placeholder='Primer apellido' type='text'") +
                    ObjetosHtml.getEntradaTexto("Segundo Apellido:", "id='a2' placeholder='Segundo apellido' type='text'") +
                    ObjetosHtml.getRadio("Genero:", ["Femenino", "Maculino"])
                +'</form>';


            var boton0 = ObjetosHtml.getButton("Guardar", "btn1");
            document.getElementById('form1').appendChild(boton0);

            /*  boton0.addEventListener("click",
                  function (e)
                  {
                      var ced = document.getElementById('ced').value;
                      var n1 = document.getElementById('n1').value;
                      var a1 = document.getElementById('a1').value;
                      var a2 = document.getElementById('a2').value;
                      var gen=document.getElementsByName("gender")[0].checked;
                      var datos = "?cedula="+ced+"&nombre="+n1+"&apellido1="+a1+"&apellido2="+a2+"&genero="+gen+"&tipo=E";
                      Conexion.agregarDatos("agregar_persona", datos);
                  });*/

            var boton1 = ObjetosHtml.getButton("Registrar", "btn1");
            /*boton1.addEventListener("click",
                function (e)
                {
                    var ced = document.getElementById('ced').value;
                    var n1 = document.getElementById('n1').value;
                    var a1 = document.getElementById('a1').value;
                    var a2 = document.getElementById('a2').value;
                    var gen=document.getElementsByName("gender")[0].checked;

                    var datos = "?cedula="+ced+"&nombre="+n1+"&apellido1="+a1+"&apellido2="+a2+"&genero="+gen+"&tipo=E";
                    Conexion.agregarDatos("agregar_persona", datos);
                });*/

            var boton2 = ObjetosHtml.getButton("Siguiente >>", "btn2");
            boton2.addEventListener("click", function (e)
            {
                $scope.informacionEmpleados = document.getElementById("ced").value;
                $scope.IntroducirDirecciones();
            });
        };

        $scope.cargarDistritos= function(id_canton)
        {
            document.getElementById("selectDistritos").innerHTML = "";
            function mostrarCantones(datos)
            {
                for(pos=0; pos<datos.length; pos++)
                {
                    var opcion = document.createElement('option');
                    var texto = document.createTextNode(datos[pos].r_nombre);
                    opcion.setAttribute('value',datos[pos].r_id);
                    opcion.appendChild(texto);
                    document.getElementById("selectCanton").appendChild(opcion);
                }
            }
            Conexion.getDatos(mostrarCantones, "get_direcciones", '?canton=' + id_canton);
        };

        $scope.cargarCantones  = function(id_provincia)
        {
            document.getElementById("selectCantones").innerHTML = "";
            function mostrarCantones(datos)
            {
                for(pos=0; pos<datos.length; pos++)
                {
                    var opcion = document.createElement('option');
                    var texto = document.createTextNode(datos[pos].r_nombre);
                    opcion.setAttribute('value',datos[pos].r_id);
                    opcion.appendChild(texto);
                    document.getElementById("selectCanton").appendChild(opcion);
                }
            }
            Conexion.getDatos(mostrarCantones, "get_cantones", '?provincia=' + id_provincia);
        };

        $scope.cargarProvincias = function (datos)
        {
            for(pos=0; pos<datos.length; pos++)
            {
                var opcion = document.createElement('option');
                var texto = document.createTextNode(datos[pos].r_nombre);
                opcion.setAttribute('value',datos[pos].r_id);
                opcion.appendChild(texto);
                document.getElementById("selectProvincia").appendChild(opcion);
            }
            document.getElementById('selectProvincia').setAttribute('ng-change', "cargarCantones(this.selectedIndex)");
            document.getElementById('selectCanton').setAttribute('ng-change', "cargarDistritos(this.selectedIndex)");
        };

        $scope.IntroducirDirecciones = function ()
        {
            document.getElementById("contenido").innerHTML="";
            document.getElementById("contenido").innerHTML +=
                ObjetosHtml.getSelect2("Provincia:", {}, {}, "selectProvincia")+
                ObjetosHtml.getSelect2("Canton:", {}, {}, "selectCanton")+
                ObjetosHtml.getSelect2("Distrito:",{}, {}, "selectCanton")+
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
            Conexion.getDatos($scope.cargarProvincias, "get_provincias", '');
        };

        $scope.insertarCorreos = function ()
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
                Conexion.agregarDatos("agregar_correo", dt);
            });
            document.getElementById("contenido").appendChild(boton1);

            var boton2 = ObjetosHtml.getButton("Siguiente>>");
            boton2.addEventListener("click", function (e)
            {
                $scope.insertarTelefonos();
            });
            document.getElementById("contenido").appendChild(boton2);
        };

        $scope.insertarTelefonos = function ()
        {
            document.getElementById("contenido").innerHTML =
                ObjetosHtml.getEntradaTexto("Numeros de telefonos:", 'tel', '0000-0000') +
                ObjetosHtml.getRadio("Genero:", ["Femenino", "Maculino"]);

            var boton2 = ObjetosHtml.getButton("+ Añadir telefono");
            boton2.addEventListener("click", function (e)
            {
                var numero = document.getElementById("tel").value;
                var dt = "?cedula="+$scope.informacionEmpleados+"&numero="+numero;
                console.log(dt);
                Conexion.agregarDatos("agregar_telefono", dt);
            });
            document.getElementById("contenido").appendChild(boton2);
            var boton3 = ObjetosHtml.getButton("Finalizar");
            boton3.addEventListener("click", function (e)
            {
                $scope.insertarCurriculum();
            });
            document.getElementById("contenido").appendChild(boton3);
        };




        $scope.mostrarEmpleados();
    });