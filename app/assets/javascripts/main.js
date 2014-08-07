var askaway = angular.module('askaway', [
 'infinite-scroll',
 'ngAnimate',
 'ngSanitize'
]);

askaway.config(function($httpProvider) {
  var authToken = $("meta[name=\"csrf-token\"]").attr("content");

  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
  $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest";
  $httpProvider.defaults.headers.common.Accept = "application/json";

  $httpProvider.interceptors.push('askaway.auth_interceptor');
});

$(".alert").alert();
