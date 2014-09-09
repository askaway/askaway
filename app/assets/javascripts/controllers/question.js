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

    $el.remove();

    $scope.toggleVote = upvotes;

    $scope.loadQuestion = function() {
      $http.get($scope.question.path + '.json').success(function(data) {
        $scope.question.error_message = undefined;
        $scope.question.answers = data.answers;
        $scope.question.answers_count = data.answers_count;
        $scope.question.can_answer = data.can_answer;
      });
    };
  }
]);
