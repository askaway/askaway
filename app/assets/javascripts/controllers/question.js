/**
 * Functionality for the GET /q/123 page.
 */
askaway.controller('QuestionCtrl', [
  '$scope',
  '$http',
  'upvotes',
  function( $scope, $http, upvotes ) {
  $scope.loadingQuestions = false;
  $scope.question = undefined;

  $scope.toggleVote = upvotes;

  loadQuestion();

  function loadQuestion() {
    var url = window.location.pathname + '.json';

    $scope.loadingQuestions = true;

    $http.get(url)
      .success(function(data) {
        $scope.loadingQuestions = false;
        $scope.question = data;
      });
  }
}]);
