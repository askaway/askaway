var askaway = angular.module('askaway', [
  'infinite-scroll',
  'ngAnimate',
  'ngRoute',
  'templates'
]);

askaway.config([
  '$httpProvider',
  '$routeProvider',
  function($httpProvider, $routeProvider) {
    var authToken = $("meta[name=\"csrf-token\"]").attr("content");

    $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;

    $routeProvider
      .when('/', {
        templateUrl: 'question_list.html',
        controller: 'QuestionsCtrl'
      })
      .when('/new_questions', {
        templateUrl: 'question_list.html',
        controller: 'QuestionsCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  }
]);

$(".alert").alert();
