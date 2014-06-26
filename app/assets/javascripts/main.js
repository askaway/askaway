var askaway = angular.module('askaway', [ 'infinite-scroll', 'ngAnimate' ]);

askaway.config(function($httpProvider) {
  var authToken = $("meta[name=\"csrf-token\"]").attr("content");

  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
});

$(".alert").alert();
