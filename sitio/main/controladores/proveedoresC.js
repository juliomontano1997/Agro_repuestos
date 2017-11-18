angular.module('moduloAdministrador')
    .controller('CtrlProveedores', function ($scope, $location, ObjetosHtml, Conexion) {

        $scope.proveedores;
        $scope.telefonos;
        $scope.correos;
        $scope.direcciones;
        $scope.cantones;
        $scope.provincias;
        $scope.distritos;
        $scope.cedula_edicion;

        $scope.modals = function(modal)
        {
            $(modal).modal('show');
        };


        $scope.mostrarProveedores= function ()
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.proveedores = datos;},"get_personas_tipo", '?tipo=P');
        };

        $scope.cargarProveedor = function(indice)
        {
            $scope.cedula_edicion = $scope.proveedores[indice].r_cedula;
            document.getElementById("e_cedula").value = $scope.proveedores[indice].r_cedula;
            document.getElementById("e_nombre").value =$scope.proveedores[indice].r_nombre;
            document.getElementById("e_apellido1").value =  $scope.proveedores[indice].r_apellido1;
            document.getElementById("e_apellido2").value =  $scope.proveedores[indice].r_apellido2;
            if( $scope.proveedores[indice].r_genero===true)
            {
                document.getElementsByName("gender")[0].checked=true;
            }
            else
            {
                document.getElementsByName("gender")[1].checked=true;
            }
            $scope.cargarCorreos($scope.proveedores[indice].r_cedula);
            $scope.cargarTelefonos($scope.proveedores[indice].r_cedula);
            $scope.cargarDirecciones($scope.proveedores[indice].r_cedula);
            $scope.cargarTodosDistritos();
            $('#edicionProveedores').modal('show');
        };


        $scope.cargarTelefonos = function (cedula)
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.telefonos= datos;},"get_telefonos",  '?cedula='+cedula);
        };


        $scope.cargarCorreos = function (cedula)
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.correos = datos;},"get_correos",  '?cedula='+cedula);
        };

        $scope.cargarDirecciones = function (cedula)
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.direcciones = datos;},"get_direcciones",  '?cedula='+cedula);
        };

        $scope.cargarProvincias = function ()
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.provincias = datos; console.log($scope.provincias)},"get_provincias", "");
        };


        $scope.cargarTodosDistritos = function ()
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.distritos = datos; },"get_distritos", "");
        };


        $scope.cargarCantones = function (provincia)
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.cantones = datos;},"get_cantones",  '?provincia='+cedula);
        };

        $scope.cargarDistritos = function (canton)
        {
            Conexion.getDatos(function (datos) { console.log(datos); $scope.direcciones = datos;},"get_direcciones",  '?cedula='+cedula);
        };



        $scope.eliminarProveedor= function (numeroProveedor)
        {

            var eliminar= confirm("¿Deseas eliminar este proveedores y toda su informacion?");
            if(eliminar)
            {

                Conexion.eliminarDatos("eliminar_persona", "?cedula="+$scope.proveedores[numeroProveedor].r_cedula);
            }
            location.reload();
        };





        $scope.eliminarCorreo = function (indice)
        {
            var correo = $scope.correos[indice].r_correo;
            var eliminar= confirm("¿Deseas eliminar este correo?");
            if(eliminar)
            {
                console.log("Direccion:"+ "eliminar_telefono", "?cedula="+$scope.cedula_edicion+"&correo="+ correo);
                Conexion.eliminarDatos("eliminar_correo", "?cedula="+$scope.cedula_edicion+"&correo="+ correo);
            }
        };



        $scope.eliminarTelefono = function (telefono)
        {

            var eliminar= confirm("¿Deseas eliminar este telefono?");
            if(eliminar)
            {
                Conexion.eliminarDatos("eliminar_telefono", "?cedula="+$scope.cedula_edicion + "&numero="+telefono);
            }
        };

        $scope.eliminarDireccion = function (id_direccion)
        {
            var eliminar= confirm("¿Deseas eliminar esta dirección?");
            if(eliminar)
            {
                Conexion.eliminarDatos("eliminar_direccion", "?id="+id_direccion);
            }
        };

        $scope.agregarCorreo = function ()
        {
            var correo = document.getElementById('e_n_correo').value;
            Conexion.agregarDatos("agregar_correo", "?cedula="+$scope.cedula_edicion+"&correo="+correo);


        };

        $scope.agregarTelefono = function ()
        {
            var telef = document.getElementById("e_n_telefono").value;
            var tipo = document.getElementsByName("e_t_telefono")[0].checked;
            Conexion.agregarDatos("agregar_telefono", "?cedula="+$scope.cedula_edicion+"&numero="+telef+"&tipo="+tipo);
        };

        $scope.agregarDireccion = function ()
        {
            var id_distrito = $scope.distritos[$('#sel_distritos')[0].selectedIndex].r_id;

            var direccion = $('#dir_exacta').val();
            console.log(id_distrito+"  "+direccion);
            Conexion.agregarDatos("agregar_direccion", "?id_distrito="+id_distrito+"&cedula="+$scope.cedula_edicion+"&direccion="+direccion);
        };






        $scope.editarTelefono = function (indice)
        {
            var telefonoViejo = $scope.telefonos[indice].r_numero;
            var telefonoEditado = document.getElementById(telefonoViejo).value;
            var tipo = document.getElementsByName(telefonoViejo)[0].checked;
            console.log("editar_telefono", "?cedula="+$scope.cedula_edicion+"&viejo="+telefonoViejo+"&nuevo="+telefonoEditado+"&tipo="+tipo);
            Conexion.agregarDatos("editar_telefono", "?cedula="+$scope.cedula_edicion+"&viejo="+telefonoViejo+"&nuevo="+telefonoEditado+"&tipo="+tipo);

        };


        $scope.editarCorreo = function (indice)
        {
            console.log(indice);
            var correoAnterior = $scope.correos[indice].r_correo;
            console.log(correoAnterior);
            var correoNuevo = document.getElementById(correoAnterior).value;
            console.log(correoNuevo);
            Conexion.agregarDatos("editar_correo", "?cedula="+$scope.cedula_edicion+"&viejo="+correoAnterior+"&nuevo="+correoNuevo);
        };

        $scope.guardar_informacion_proveedor = function()
        {
            var ced = $scope.cedula_edicion;
            var n1 = document.getElementById('e_nombre').value;
            var a1 = document.getElementById('e_apellido1').value;
            var a2 = document.getElementById('e_apellido2').value;
            var gen=document.getElementsByName("gender")[0].checked;
            var datos = "?cedula="+ced+"&nombre="+n1+"&apellido1="+a1+"&apellido2="+a2+"&genero="+gen+"&tipo=E";
            Conexion.agregarDatos("modificar_persona", datos);
        };


        $scope.nuevoProveedor= function ()
        {
            console.log("Goa");
            var datos = document.getElementsByName("datos_persona");
            var gen=document.getElementsByName("gender")[0].checked;
            var datos2 = "?cedula="+datos[0].value+"&nombre="+datos[1].value+"&apellido1="+datos[2].value+"&apellido2="+datos[3].value+"&genero="+gen+"&tipo=P";
            console.log(datos2);
            Conexion.agregarDatos("agregar_persona", datos2);
            location.reload();
        };
        $scope.mostrarProveedores();
    });