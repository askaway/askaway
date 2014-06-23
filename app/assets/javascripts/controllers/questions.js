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
      $http.post('/questions/' + question.id + '/votes', null, {
        headers: {
          Accept: 'application/json'
        }
      })
        .success(function(vote) {
          question.votes_count++;
          question.vote_id = vote.id;
        })
        .error(function(data, status) {
          if (status === 401) {
            $('#login-modal').modal('show');
          }
          // FIXME handle other error statuses ... message box?
        });
    }
  };

  $scope.toggleQuestion = function(e) {
    if ($(e.target).closest('a').length === 0) {
      this.question.expanded = !this.question.expanded;
    }
  };
}]);

askaway.controller( 'QuestionFormCtrl', ['$scope', function( $scope ) {
}]);
