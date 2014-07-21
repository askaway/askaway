askaway.controller('AnswerFormCtrl', ['$scope', '$http', function($scope, $http) {
  $scope.addAnswer = function() {
    $http.post(this.question.path + '/answers', {
      answer: {
        body: this.question.answerText
      }
    })
      .success(function(question) {
        $scope.question.answers = question.answers;
        $scope.question.answers_count = question.answers_count;
        $scope.question.can_answer = question.can_answer;
      })
      .error(function(data, status) {
        if (Math.floor(status / 100) === 4) {
          $('#login-modal').modal('show');
        }
      });
  };
}]);
