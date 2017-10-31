var app = angular.module('loginModule',["ngRoute","ngResource"])
        .controller('loginController', function($scope, $http) 
{
        $scope.username = "go";
        $scope.password = "";

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


