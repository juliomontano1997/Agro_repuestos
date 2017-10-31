var app = angular.module('loginModule',["ngRoute","ngResource"])


app.controller('loginController', function($scope, $http)
{
        $scope.username = "";
        $scope.password = "";


        // En esta parte se verifican las contraseñas y nombres de usuario.
        // Por el momento solamente se cambia a la pagina de administracion


        $scope.doLogin = function ()
        {                            
                window.location.href = ('main/main.html');
        };


        function saveSession(json) {
            localStorage.setItem("session.token", json.session.token);
            localStorage.setItem("session.owner", JSON.stringify(json.user));
            console.log("Sesión guardada.");
        }
    });


