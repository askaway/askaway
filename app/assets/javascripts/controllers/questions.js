askaway.controller('QuestionsCtrl', ['$scope', '$http', function( $scope, $http ) {
  $scope.loadingQuestions = false;
  $scope.questionList = [];
  $scope.page = 1;

  function requireLogin(data, status) {
    if (Math.floor(status / 100) === 4) { // 4xx status
      $('#login-modal').modal('show');
    }
  }

  $scope.toggleVote = function() {
    var question = this.question;

    if (question.vote_id) {
      $http.delete('/votes/' + question.vote_id)
        .success(function(vote) {
          question.votes_count--;
          question.vote_id = undefined;
        })
        .error(requireLogin);
    } else {
      $http.post(question.path + '/votes', null, {
        headers: {
          Accept: 'application/json'
        }
      })
        .success(function(vote) {
          question.votes_count++;
          question.vote_id = vote.id;
        })
        .error(requireLogin);
    }
  };

  $scope.toggleQuestion = function(e) {
    link = $(e.target).closest('a');
    if ((link.length === 0) || link.hasClass('question-toggle')) {
      this.question.expanded = !this.question.expanded;
    }
  };

  $scope.loadQuestions = function() {
    var url = getUrl();

    $scope.loadingQuestions = true;

    $http.get(url).success(function(data) {
      var i = 0;

      $scope.loadingQuestions = false;
      for (; i < data.length; i++) {
        $scope.questionList.push(data[i]);
      }
    });
  };

  function getUrl() {
    var resource = window.location.hash;

    resource = resource.replace(/^#/, '');

    if (resource === '/') {
      resource = '/trending';
    }

    return resource + '.json?page=' + $scope.page++;
  }
}]);

askaway.controller( 'QuestionFormCtrl', ['$scope', function( $scope ) {
}]);
