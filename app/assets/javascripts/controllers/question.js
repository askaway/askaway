/**
 * Functionality for the GET /q/123 page.
 */
askaway.controller('QuestionCtrl', [
  '$scope',
  '$http',
  'upvotes',
  function( $scope, $http, upvotes ) {
    var $el = angular.element('#question-data');

    $scope.question = JSON.parse($el.html());

    $scope.toggleVote = upvotes;
  }
]);
