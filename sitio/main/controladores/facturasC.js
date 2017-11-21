angular.module('moduloAdministrador')
.controller('CtrlFacturas', function ($scope, $location, Conexion)
{
    $scope.facturas;
    $scope.productos;
    $scope.productosFactura;
    $scope.clientes;
    $scope.administradores;
    $scope.tipo_pagos = TIPO_PAGO;
    $scope.productosSeleccionados=[];
    $scope.clientesFactura;
    $scope.id_factura_edicion;


    function cargarFacturas()
    {
        Conexion.getDatos(function (datos) {$scope.facturas = datos;}, "get_facturas","");
        Conexion.getDatos(function (datos) {$scope.productos= datos;}, "get_productos","");
        Conexion.getDatos(function (datos){$scope.clientes=datos;}, "get_personas_tipo","?tipo=C");
        Conexion.getDatos(function (datos) {$scope.clientesFactura=datos;$scope.administradores=datos;}, "get_personas_tipo","?tipo=A");
    }

    $scope.cambiarClientes= function(numero)
    {
        console.log($scope.clientesFactura);
        if(numero===1)
        {
            $scope.clientesFactura = $scope.administradores;
        }
        else
        {
            $scope.clientesFactura = $scope.clientes;
        }
    };

    $scope.agregarFactura = function()
    {
        var tipo = document.getElementsByName("tipo_nueva_factura")[0].checked;
        var cedula=0;
        if(tipo)
        {
            cedula = $scope.administradores[document.getElementById("i1").selectedIndex].r_cedula;
        }
        else
        {
            cedula = $scope.clientes[document.getElementById("i1").selectedIndex].r_cedula;
        }
        var tipoPago = $scope.tipo_pagos[document.getElementById("i3").selectedIndex];
        var fecha = document.getElementById("i2").value;

        var datos = "?cedula="+cedula+"&tipoPago="+tipoPago+"&tipo="+tipo+"&fecha="+fecha;
        Conexion.agregarDatos("agregar_factura", datos);
        location.reload();

    };

    $scope.guardarFacturaEditada = function()
    {
        var tipo = document.getElementsByName("tipo_edicion_factura")[0].checked;
        var cedula=0;
        if(tipo)
        {
            cedula = $scope.administradores[document.getElementById("e1").selectedIndex].r_cedula;
        }
        else
        {
            cedula = $scope.clientes[document.getElementById("e1").selectedIndex].r_cedula;
        }
        var tipoPago = $scope.tipo_pagos[document.getElementById("e3").selectedIndex];
        var fecha = document.getElementById("e2").value;

        var datos = "?cedula="+cedula+"&tipoPago="+tipoPago+"&tipo="+tipo+"&fecha="+fecha;
        Conexion.agregarDatos("editar_factura", datos);
    };

    $scope.cargarFactura = function (indice)
    {

        var factura = $scope.facturas[indice];
        console.log(factura);
        $scope.id_factura_edicion=factura.r_id;
        Conexion.getDatos(function (datos){$scope.productosFactura= datos; console.log($scope.productosFactura)},"get_productos_factura","?id_factura="+$scope.id_factura_edicion);
        document.getElementsByName("tipo_edicion_factura")[0].checked= factura.r_tipo;
        document.getElementsByName("tipo_edicion_factura")[1].checked= !(factura.r_tipo);

        if(factura.r_tipo)
        {
            var maximo = $scope.administradores.length;
            for(i=0; i<maximo; i++)
            {
                if(factura.r_cedula ===$scope.administradores[i].r_cedula)
                {
                    document.getElementById("e1").selectedIndex=i;
                }
            }
        }
        else
        {
            var maximo = $scope.clientes.length;
            for(i=0; i<maximo; i++)
            {
                if(factura.r_cedula ===$scope.clientes[i].r_cedula)
                {
                    document.getElementById("e1").selectedIndex=i;
                }
            }
        }

        var maximo = $scope.tipo_pagos.length;
        for(i=0; i<maximo; i++)
        {
            if(factura.r_tipo_pago ===$scope.tipo_pagos[i])
            {
                document.getElementById("e3").selectedIndex=i;
            }
        }
        document.getElementById("e2").value = factura.r_fecha.toString().slice(0, 10) ;
        $("#modal_editar_factura").modal("show");
    };


    $scope.agregarProductoAFactura= function()
    {
        var producto = $scope.productos[document.getElementById("e5").selectedIndex];
        var cantidad = document.getElementById("e4").value;
        Conexion.agregarDatos("agregar_productos_factura", "?id_producto="+producto.r_id+
                                "&id_factura="+$scope.id_factura_edicion+"&cantidad="+cantidad+"&precio="+producto.r_precio);
        Conexion.getDatos(function (datos){$scope.productosFactura= datos;},"get_productos_factura","?id_factura="+$scope.id_factura_edicion);

    };


    $scope.eliminarFactura = function (indice)
    {
        var id_fact = $scope.facturas[indice].r_id;

        var eliminar = confirm("Desea eliminar esta factura?");
        if(eliminar)
        {
            Conexion.eliminarDatos("eliminar_factura", "?id="+id_fact);
            location.reload();
        }
    };


    cargarFacturas();
});