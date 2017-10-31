angular.module('moduloAdministrador',["ngRoute","ngResource"])
.config(['$routeProvider',function($routeProvider){
    $routeProvider
    .when("/inicio",{templateUrl:'secciones/inicio.html',controller:'CtrlInicio'})  
    .when("/empleados",{templateUrl:'secciones/empleados.html',controller:'CtrlEmpleados'})
    .when("/productos",{templateUrl:'secciones/productos.html',controller:'CtrlProductos'})
    .when("/ventas",{templateUrl:'secciones/ventas.html',controller:'CtrlVentas'})
    .when("/clientes",{templateUrl:'secciones/clientes.html',controller:'CtrlClientes'})
    .when("/proveedores",{templateUrl:'secciones/proveedores.html',controller:'CtrlProveedores'});
}])
.factory('Conexion', function ()
{    
    var funciones = {
        obtenerDatos: function (funcion, nombreQuery, parametros)
        {            
            var direccion = "controladores/consultas.php?NF=" + nombreQuery;            
            for (var i = 0; i < parametros.length; i++) 
            {
                direccion += '&' + parametros[i];
            }            
            var consuta = new XMLHttpRequest();
            consuta.open("GET", direccion);
            consuta.onreadystatechange = function ()
            {
                if (this.readyState === 4 && this.status === 200)
                {
                    var datos = this.responseText.toString();                  
                }
            };
            consuta.send();
        },
        eliminarDatos: function (nombreQuery, parametros)
        {            
            var direccion = "/consultas.php?NF=" + nombreQuery;               
            for (var i = 0; i < parametros.length; i++) 
            {
                direccion += '&' + parametros[i];
            }            
            var consulta = new XMLHttpRequest();
            consulta.open("GET", direccion);
            consulta.onreadystatechange = function ()
            {
                if (this.readyState === 4 && this.status === 200)
                {
                    var datos = eval(this.responseText);                    
                }
            };
            consulta.send();
        },
        actualizarDatos: function(nombreQuery, parametros)
        {                     
            var direccion = "/consultas.php?NF=" + nombreQuery;               
            for (var i = 0; i < parametros.length; i++) 
            {
                direccion += '&' + parametros[i];
            }            
            var consulta = new XMLHttpRequest();
            consulta.open("GET", direccion);
            consulta.onreadystatechange = function ()
            {
                if (this.readyState === 4 && this.status === 200)
                {
                    var datos = eval(this.responseText);
                    console.log(direccion);                    
                    console.log(datos);                    
                }
            };
            consulta.send();                    
        }
    };
    return funciones;
})
.factory('ObjetosHtml', function ()
{
    var funciones ={
        getEntradaTexto: function (texto, id, textPredefinido, value = "", tipo = "text")
        {
            var resp = '<div class="form-group"> <label >' + texto + '</label><input type="' + tipo + '" class="form-control" id= "' + id + '" value="' + value + '" placeholder="' + textPredefinido + '"></div>';
            return resp;
        },

        getButton: function (texto)
        {
            var resp = document.createElement("input");
            resp.type = "button";
            resp.className = "btn btn-default";
            resp.value = texto;
            return resp;
        },
        getTable: function (nombreColumnas)
        {
            var texto = '<table id="tablaDatos" class="table table-striped" >' + '<thead>';

            var max = nombreColumnas.length;
            var pos;
            for (pos = 0; pos < max; pos++)
            {
                texto += '<th>' + nombreColumnas[pos] + '</th>';
            }
            texto += '</thead><tbody> </tbody></table>';
            return texto;
        },
        getTextArea: function (texto, id)
        {
            return '<div class="form-group"><label for="comment">' + texto + '</label><textarea class="form-control" rows="5" id="' + id + '"></textarea></div>';
        },
        getSelect: function (texto, opciones, id = "select1")
        {
            var texto = '<div class="form-group" id="opciones" > <label >' + texto + '</label><select class="form-control" id="sel1" style="width: 200px">';

            var max = opciones.length;
            var pos;
            for (pos = 0; pos < max; pos++)
            {
                texto += '<option>' + opciones[pos] + '</option>';
            }
            texto += ' </select></div>  ';
            return texto;
        }
    };
    return funciones;
})
