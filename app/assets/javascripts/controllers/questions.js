askaway.controller('QuestionsCtrl', ['$scope', '$http', function( $scope, $http ) {
  $scope.loadingQuestions = false;
  $scope.questionList = [];
  $scope.page = 1;

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

  $scope.loadQuestions = function() {
    $scope.loadingQuestions = true;
    $http.get('/trending.json?page=' + $scope.page++).success(function(data) {
      var i = 0;

      $scope.loadingQuestions = false;
      for (; i < data.length; i++) {
        $scope.questionList.push(data[i]);
      }
    });
  };
}]);

askaway.controller( 'QuestionFormCtrl', ['$scope', function( $scope ) {
}]);
