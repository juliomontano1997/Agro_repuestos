var app = angular.module('loginModule',["ngRoute","ngResource"])


app.controller('loginController', function($scope, $http)
{
        $scope.username = "";
        $scope.password = "";
        $scope.doLogin = function ()
        {
            $http({method : "GET", url:'http://localhost:8081/autenticacion?user='+$scope.username+'&password='+$scope.password})
                .then(
                    function mySucces(response)
                    {
                        alert(response);
                        console.log(response);
                        if(response.data[0].mg_login===true) {window.location.href = ('main/main.html');}
                        else {alert("Hubo un error en la peticion");}
                    },
                    function myError(response) {alert("No tienes conexion");});
        };
    });


