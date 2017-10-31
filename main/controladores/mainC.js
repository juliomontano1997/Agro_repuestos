angular.module('moduloAdministrador')
    .factory('Conexion', function ($http)
    {
        var funciones = {
            getDatos : function (funcion,nombreQuery, parametros="")
            {
                var direccion = "http://localhost:8081/"+ nombreQuery+parametros;
                console.log(direccion);
                $http({method : "GET", url :direccion})
                    .then(function mySucces(response) {
                            if(response.data==="false")
                            {
                                alert("Hubo un error en la peticion");
                                return;
                            }
                            funcion(response.data.rows);
                        },
                        function myError(response) {alert("No tienes conexion a la base de datos");});
            },
            eliminarDatos: function (nombreQuery, parametros)
            {
                var direccion = "http://localhost:8081/"+ nombreQuery+parametros;
                console.log(direccion);
                $http({method : "DELETE", url :direccion})
                    .then(function mySucces(response)
                        {  console.log(response);
                            if(response.data==="false")
                            {
                                alert("Existen dependencias del objeto que se quiere eliminar");
                                return;
                            }
                            alert("X  Eliminado");
                            return;
                        },
                        function myError(response) {
                            alert("Error interno");
                            return ;
                        });
            },
            actualizarDatos: function(nombreQuery, parametros)
            {
                var direccion = "http://localhost:8081/"+ nombreQuery+parametros;
                $http({method : "POST", url :direccion})
                    .then(function mySucces(response) {
                            alert("Edicion completada");
                        },
                        function myError(response) {alert("No tienes conexion a la base de datos");});
            },
            agregarDatos: function(nombreQuery, parametros,ventana)
            {
                var direccion = "http://localhost:8081/"+ nombreQuery+parametros;
                $http({method : "POST", url :direccion})
                    .then(function mySucces(response)
                        {
                            console.log(response);
                            if(response.data==="false")
                            {
                                alert(":(  ocurrio un error en la insercion");
                            }
                            else
                            {
                                alert(":)  Se añadio exitosamente");
                            }

                        },
                        function myError(response) {alert(":(  Un error ocurrio, intentalo mas tarde");});
            }
        };
        return funciones;
    })
    .factory('ObjetosHtml', function ()
    {
        var funciones ={
            getEntradaTexto: function (texto, id, textPredefinido, value = "", tipo = "text")
            {
                var resp = '<div class="form-group"> <label style="color:#fff">' + texto + '</label><input type="' + tipo + '" class="form-control" id= "' + id + '" value="' + value + '" placeholder="' + textPredefinido + '"></div>';
                return resp;
            },

            getButton: function (texto, id="btn")
            {
                var resp = document.createElement("input");
                resp.type = "button";
                resp.className = "btn btn-default";
                resp.value = texto;
                resp.id = id;
                return resp;
            },
            getTable: function (nombreColumnas, id="tablaDatos")
            {
                var texto = '<table style="color:#fff" id="'+ id +'" class="table table-striped" >' + '<thead>';

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
                return '<div class="form-group"><label style="color:#fff" for="comment">' + texto + '</label><textarea class="form-control" rows="5" id="' + id + '"></textarea></div>';
            },
            getSelect: function (texto , opciones, id = "select1")
            {
                var texto = '<div class="form-group" id="opciones" > <label style="color:#fff" >' + texto + '</label><select class="form-control" id="'+id+'" style="width: 200px">';

                var max = opciones.length;
                var pos;
                for (pos = 0; pos < max; pos++)
                {
                    texto += '<option value="'+opciones+'">' + opciones[pos] + '</option>';
                }
                texto += ' </select></div>  ';
                return texto;
            },
            getSelect2: function (texto , opciones, valores, id = "select1")
            {
                var texto = '<div class="form-group" id="opciones" > <label style="color:#fff" >' + texto + '</label><select class="form-control" id="'+id+'" style="width: 200px">';

                var max = opciones.length;
                var pos;
                for (pos = 0; pos < max; pos++)
                {
                    texto += '<option value="'+valores[pos]+'">' + opciones[pos] + '</option>';
                }
                texto += ' </select></div>  ';
                return texto;
            },
            getRadio: function (texto , opciones)
            {
                var texto = '<div class="form-group" id="opciones" > <label style="color:#fff" >' + texto + '</label><br>';

                var max = opciones.length;
                var pos;
                for (pos = 0; pos < max; pos++)
                {
                    console.log()
                    texto += '<input type="radio" name="gender" >'+'<label style="color:#fff" >' + opciones[pos]+ '</label>'+
                        '<br>';
                }
                texto += '</div>  ';
                return texto;
            }
        };
        return funciones;
    })
    .controller('CtrlInicio', function ($scope, $location, ObjetosHtml, Conexion)
    {
    });

