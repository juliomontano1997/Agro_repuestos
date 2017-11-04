angular.module('moduloAdministrador')
    .controller('CtrlVentas', function ($scope, $location, ObjetosHtml, Conexion)
    {
        $scope.variable =0;
        $scope.verRegistro= function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Nombre cliente", "Nombre empleado", "Fecha    hora", "Monto total"]);
            var tabla = document.getElementById("tablaDatos");
            function  llenarTabla(datos)
            {
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    var celda4 = fila.insertCell(3);
                    celda1.innerHTML = datos[i].nc;
                    celda2.innerHTML =datos[i].ne;
                    celda3.innerHTML  = datos[i].fechaemision;
                    celda4.innerHTML  = datos[i].montototal;
                }
            }
            Conexion.getDatos(llenarTabla, "ventas");
        };


        $scope.ventasPorCliente0= function ()
        {
            document.getElementById("contenido").innerHTML="";
            function cargarClientes(datos)
            {
                console.log(datos);
                var array1 = [];
                var array2 = [];
                var pos=0;
                for(pos=0; pos<datos.length; pos++)
                {
                    array1[pos] = datos[pos].nombre;
                    array2[pos] = datos[pos].cedula;
                    console.log(array1[pos]+array2[pos]);
                }
                document.getElementById("contenido").innerHTML += ObjetosHtml.getSelect2("Clientes:", array1, array2, "selCli");

                var boton1 = ObjetosHtml.getButton("Ver registros", "btn1");
                boton1.addEventListener("click", function (e)
                {
                    var id = document.getElementById("selCli").value;
                    $scope.variable  = '?cedula='+id;
                    $scope.ventasPorCliente();
                });
                document.getElementById("contenido").appendChild(boton1);
            }
            Conexion.getDatos(cargarClientes, "clientes");
        };

        $scope.ventasPorCliente= function ()
        {
            console.log($scope.variable);
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Nombre cliente", "Nombre empleado", "Fecha    hora", "Monto total"]);
            var tabla = document.getElementById("tablaDatos");
            function  llenarTabla(datos)
            {
                if(datos.length==0)
                {
                    alert("No hay registro de ventas");
                }
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    var celda4 = fila.insertCell(3);
                    celda1.innerHTML = datos[i].nc;
                    celda2.innerHTML =datos[i].ne;
                    celda3.innerHTML  = datos[i].fechaemision;
                    celda4.innerHTML  = datos[i].montototal;
                }
            }
            Conexion.getDatos(llenarTabla, "ventasCliente",$scope.variable);
        };



        $scope.ventasPorMes0= function ()
        {
            var array2 = [1, 2, 3, 4, 5, 6, 7,8 ,9, 10, 11,12];
            var array1 = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"];
            document.getElementById("contenido").innerHTML = ObjetosHtml.getSelect2("Clientes:", array1, array2, "selmes");

            var boton1 = ObjetosHtml.getButton("Ver registros", "btn1");
            boton1.addEventListener("click", function (e)
            {
                var id = document.getElementById("selmes").value;
                $scope.variable  = '?mes='+id;
                $scope.ventasPorMes();
            });
            document.getElementById("contenido").appendChild(boton1);
        };

        $scope.ventasPorMes= function ()
        {
            document.getElementById("contenido").innerHTML = ObjetosHtml.getTable(["Nombre cliente", "Nombre empleado", "Fecha    hora", "Monto total"]);
            var tabla = document.getElementById("tablaDatos");
            function  llenarTabla(datos)
            {
                if(datos.length===0)
                {
                    alert("No hay registros en este mes");
                }
                for (i = 0; i <datos.length; i++)
                {
                    var fila = tabla.insertRow();
                    var celda1 = fila.insertCell(0);
                    var celda2 = fila.insertCell(1);
                    var celda3 = fila.insertCell(2);
                    var celda4 = fila.insertCell(3);
                    celda1.innerHTML = datos[i].nc;
                    celda2.innerHTML =datos[i].ne;
                    celda3.innerHTML  = datos[i].fechaemision;
                    celda4.innerHTML  = datos[i].montototal;
                }
            }
            Conexion.getDatos(llenarTabla, "ventasMes", $scope.variable);
        };



    });