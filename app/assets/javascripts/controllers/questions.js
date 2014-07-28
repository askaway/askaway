askaway.controller('QuestionsCtrl', ['$scope', '$http', function( $scope, $http ) {
  $scope.loadingQuestions = false;
  $scope.questionList = [];
  $scope.page = 1;

  $scope.toggleVote = toggleVote($http);

  $scope.toggleQuestion = function(e) {
    var $target = $(e.target),
      $veto = $target.closest('a[href], form');

    if ($veto.length === 0) {
      this.question.expanded = !this.question.expanded;
    }
  };

  $scope.loadQuestion = function() {
    var me = this;

    $scope.loadingQuestions = true;

    $http.get(me.question.path).success(function(data) {
      $scope.loadingQuestions = false;

      me.question.error_message = undefined;
      me.question.answers = data.answers;
      me.question.answers_count = data.answers_count;
      me.question.can_answer = data.can_answer;
    });
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
    var resource = window.location.pathname;

    if (resource === '/') {
      resource = '/trending';
    }

    return resource + '.json?page=' + $scope.page++;
  }
}]);

askaway.controller('QuestionCtrl', ['$scope', '$http', function( $scope, $http ) {
  $scope.loadingQuestions = false;
  $scope.question = undefined;

  $scope.toggleVote = toggleVote($http);

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

askaway.controller( 'QuestionFormCtrl', ['$scope', function( $scope ) {
}]);

/**
 * Returns a function after the $http provider is in scope
 */
function toggleVote($http) {
  return function() {
    var question = this.question,
      vote_id = question.vote_id;

    if (question.togglingVote) {
      return;
    }

    question.togglingVote = true;

    if (question.vote_id) {
      question.votes_count--;
      $http.delete('/votes/' + question.vote_id)
        .success(function(vote) {
          question.vote_id = undefined;
          question.togglingVote = undefined;
        })
        .error(function(data, status) {
          question.togglingVote = false;
          question.votes_count++;
        });
    } else {
      question.votes_count++;
      $http.post(question.path + '/votes', null)
        .success(function(vote) {
          question.vote_id = vote.id;
          question.togglingVote = undefined;
        })
        .error(function(data, status) {
          question.togglingVote = false;
          question.votes_count--;
        });
    }
  };
}
