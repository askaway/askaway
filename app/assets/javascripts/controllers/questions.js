askaway.controller('QuestionsCtrl', ['$scope', '$http', function( $scope, $http ) {
  $http.get('/trending.json').success(function(data) {
    $scope.questionList = data;
  });

  $scope.toggleVote = function() {
    var question = this.question;

    if (question.vote_id) {
      $http.delete('/votes/' + question.vote_id).success(function(vote) {
        question.votes_count--;
        question.vote_id = undefined;
      });
    } else {
      $http.post('/questions/' + question.id + '/votes.json')
        .success(function(vote) {
          question.votes_count++;
          question.vote_id = vote.id;
        })
        .error(function(data, status) {
          if (status === 401) {
            $('#login-modal').modal('show');
          }
        });
    }
  };
}]);

askaway.controller( 'QuestionFormCtrl', ['$scope', function( $scope ) {
}]);
