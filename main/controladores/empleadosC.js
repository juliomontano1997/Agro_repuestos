angular.module('moduloAdministrador')
.controller('CtrlEmpleados', function ($scope, $location,$http,  ObjetosHtml, Conexion)
{
    $scope.informacionEmpleados;
    function actualizarInfo()
    {
        console.log("eokrgronorehno");
            $http({   
                method : "GET",
                url :"http://localhost:8081/empleados"
            }).then(function mySucces(response) {
                $scope.informacionEmpleado = response.data;
                console.log($scope.informacionEmpleado);
            }, function myError(response) {                    
                mostrarNotificacion("Ocurrio un error",1);
                $scope.myWelcome = response.statusText;
            });
    }
    $scope.registroEmpleados = function () 
    {        
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Numero", "Cedula", "Nombre"]);
        
        function  llenartabla(datos)
        {
            
            var tabla = document.getElementById("tablaDatos");                        
            for (i = 0; i < datos.length; i++)
            {                
                var fila = tabla.insertRow();
                var celda1 = fila.insertCell(0);
                var celda2 = fila.insertCell(1);
                var celda3 = fila.insertCell(2);
                celda1.innerHTML = i + 1;
                celda2.innerHTML = datos[i].cedula;
                celda3.innerHTML = datos[i].nombre + '    ' + datos[i].apellido1;
            }
        }
        actualizarInfo();
        //Conexion.obtenerDatos(llenartabla, "empleados", []);
    };    
    
    $scope.NuevoRegistro = function ()  //Cargar el  formulario de registro
    {
        document.getElementById("contenido").innerHTML = '<form>' +
        ObjetosHtml.getEntradaTexto("Nombre", "n1", "Nombre") +
        ObjetosHtml.getEntradaTexto("Primer Apellido", 'a1', 'Primer apellido') +
        ObjetosHtml.getEntradaTexto("Segundo Apellido", 'a2', 'Segundo apellido') +
        ObjetosHtml.getEntradaTexto("Numero de identificacion", 'ced', 'indentificacion') +
        ObjetosHtml.getEntradaTexto("Correo electronico", 'email', 'ejemplo1@gmail.com,ejemplo2@gmail.com') +
        ObjetosHtml.getEntradaTexto("Numeros de telefonos", 'tel', '0000-0000,0000-0000') +
        ObjetosHtml.getEntradaTexto("Salario por hora", 'salario', '00000') +
        ObjetosHtml.getTextArea("Hoja de delincuencia") +
        ObjetosHtml.getTextArea("Historial de estudio") +   

        ObjetosHtml.getTable(["Nombre empresa", "Duracion", "Puesto"])+
        ObjetosHtml.getSelect("Genero", ["Femenino", "Maculino", "Otro"]) +
        ObjetosHtml.getSelect("Estado civil", ["Soltero(a)", "Viudo(a)", "Divorciado(a)", "Casado(a)", "Union libre"]) +
        '</form>';

        var boton = ObjetosHtml.getButton("Registrar");
        boton.addEventListener("click", function (e) {
            // Aqui realiza la insercion 
        });
        document.getElementById("contenido").appendChild(boton);
    };
    
    $scope.borrarEmpleadoForm = function () // Carga el formulario de borrado de empleado
    {
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["","Cedula", "Nombre", ""]);
        function  llenartabla(datos)
        {
            var tabla = document.getElementById("tablaDatos");
            console.log(datos);
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
                    var eliminar=confirm("¿Deseas eliminar este empleaso?");
                    if(eliminar)
                    {
                       Conexion.eliminarDatos("borrarEmpleado", ["ced="+this.id]);
                    }
                });
                celda4.appendChild(boton);
            }
        }
        Conexion.obtenerDatos(llenartabla, "empleados", []);
    };

    $scope.editEmpleadoForm = function ()  // Carga un formulario con todos los campos del empleado
    {
        // 1.Hacer consulta a la base de datos con el numero de cedula       
        document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Cedula", "Nombre", "Puesto", ""]);

        function  llenartabla(datos)
        {
            var tabla = document.getElementById("tablaDatos");
            for (i = 0; i < datos.length; i++)
            {
                var fila = tabla.insertRow();
                fila.backgroud = "white";
                var celda1 = fila.insertCell(0);
                var celda2 = fila.insertCell(1);
                var celda3 = fila.insertCell(2);
                var celda4 = fila.insertCell(3);
                celda1.innerHTML = i + 1;
                celda2.innerHTML = datos[i].telefono;
                celda3.innerHTML = datos[i].nombre + ' ' + datos[i].apellido1;
                
                var boton = ObjetosHtml.getButton("Editar");
                boton.id = datos.telefono;
                boton.addEventListener("click", function (e)
                {
                    var cedula = this.id;
                    if (true) // verificar que este en la base de datos 
                    {
                        // cargar la interfas de edicion
                        document.getElementById("contenido").innerHTML =
                                ObjetosHtml.getEntradaTexto("Nombre", "n1", "Nombre", "valor") +
                                ObjetosHtml.getEntradaTexto("Primer Apellido", 'a1', 'Primer apellido', "valor") +
                                ObjetosHtml.getEntradaTexto("Segundo Apellido", 'a2', 'Segundo apellido', "valor") +
                                ObjetosHtml.getEntradaTexto("Numero de identificacion", 'ced', 'indentificacion', "valor") +
                                ObjetosHtml.getSelect("Genero", ["Femenino", "Maculino", "Otro"]);

                        var boton = ObjetosHtml.getButton("Guardar");
                        boton.addEventListener("click", function (e)
                        {
                            $scope.guardarEditado();
                        });
                        document.getElementById("contenido").appendChild(boton);
                    }
                });
                celda4.appendChild(boton);
            }
        }
        Conexion.obtenerDatos(llenartabla, "getAllUsuarios", []);
    };
   

    $scope.verificarEspacios = function (arreglo) // verifica que todas las entradas de texto esten llenas 
    {

    };
    console.log("LLego");
    $scope.registroEmpleados();  // Muestra la lista de empleados actuales 
});