angular.module('moduloAdministrador',["ngRoute","ngResource"])
    .config(['$routeProvider',function($routeProvider)
    {
        $routeProvider
            .when("/inicio",{templateUrl:'secciones/inicio.html',controller:'CtrlInicio'})

            .when("/empleados",{templateUrl:'secciones/empleados/empleados.html',controller:'CtrlEmpleados'})
            .when("/n_empleado",{templateUrl:'secciones/empleados/nuevo.html',controller:'CtrlEmpleados'})
            .when("/m_empleado",{templateUrl:'secciones/empleados/modificar.html',controller:'CtrlEmpleados'})
            .when("/e_empleado",{templateUrl:'secciones/empleados/eliminar.html',controller:'CtrlEmpleados'})

            .when("/productos",{templateUrl:'secciones/productos.html',controller:'CtrlProductos'})
            .when("/ventas",{templateUrl:'secciones/ventas.html',controller:'CtrlVentas'})
            .when("/clientes",{templateUrl:'secciones/clientes.html',controller:'CtrlClientes'})
            .when("/proveedores",{templateUrl:'secciones/proveedores.html',controller:'CtrlProveedores'});
    }]);
