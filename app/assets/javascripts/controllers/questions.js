askaway.controller('QuestionsCtrl', ['$scope', '$http', function( $scope, $http ) {
  $scope.loadingQuestions = false;
  $scope.questionsInitialized = false;
  $scope.questionList = [];
  $scope.page = 1;

  $scope.toggleVote = toggleVote($http);

  $scope.shareQuestion = function(e, question) {
    var shareSelector = "#share-question-" + question.id
    if (question.sharesLoaded != true) {
      var twitterSelector = "#share-question-btn-twitter-" + question.id
      var facebookSelector = "#share-question-btn-facebook-" + question.id
      var questionUrl = document.URL + question.path
      var twitterLink = '<a href="https://twitter.com/share" class="twitter-share-button" data-url="' + questionUrl + '" data-lang="en">Tweet</a>';
      var facebookLink = '<div class="fb-like" data-href="' + questionUrl + '" data-layout="button_count" data-action="like" data-show-faces="false" data-share="false"></div>';
      $(twitterSelector).html(twitterLink);
      $(facebookSelector).html(facebookLink);
      twttr.widgets.load();
      FB.XFBML.parse(document.getElementById(shareSelector), function() {
        $(shareSelector + ' .share-question-buttons').removeClass('hide');
        $(shareSelector + ' .loading-spinner').addClass('hide');
      });
      question.sharesLoaded = true;
    }
  }

  $scope.toggleQuestion = function(e) {
    var $target = $(e.target),
      $veto = $target.closest('a[href], form');

    if (window.getSelection && window.getSelection().toString() !== '') return;

    if ($veto.length === 0) {
      this.question.expanded = !this.question.expanded;
    }
  };

  $scope.loadQuestion = function() {
    var me = this;

    $scope.loadingQuestions = true;

    $http.get(me.question.path + '.json').success(function(data) {
      $scope.loadingQuestions = false;

      me.question.error_message = undefined;
      me.question.answers = data.answers;
      me.question.answers_count = data.answers_count;
      me.question.can_answer = data.can_answer;
    });
  };

  // place data into questionList
  function loadData(data) {
    for (var i = 0; i < data.length; i++) {
      $scope.questionList.push(data[i]);
    }

    if (data.length === 0) {
      $scope.noMoreQuestions = true;
    }
  }

  $scope.loadQuestions = function() {
    var url = getUrl(), // always getUrl to advance page count sanely...
      $questions;

    // do initial loading
    if ($scope.questionList.length === 0) {
      $questions = angular.element('#question-data');
      loadData(JSON.parse($questions.html()));
      $questions.remove();
      return;
    } else if ($scope.noMoreQuestions) {
      return;
    }

    $scope.loadingQuestions = true;

    $http.get(url).success(function(data) {
      $scope.loadingQuestions = false;
      loadData(data);

      $scope.questionsInitialized = true;
    });
  };

  function getUrl() {
    var resource = window.location.pathname;
    var args = "&" + window.location.search.replace("?", "");

    if (resource === '/') {
      resource = '/trending';
    }

    return (resource + '.json?page=' + $scope.page++ + args);
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
  $scope.submit = function() {
    $scope.new_question.$setPristine();
  };
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

    if (vote_id) {
      // short circuit if we're trying to unvote for something still in progress.
      if (vote_id === 'voting-in-progress') {
        return;
      }

      question.votes_count--;
      question.vote_id = undefined;
      $http({
        method: 'DELETE', // IE8 fail. http://tech.pro/tutorial/1238/angularjs-and-ie8-gotcha-http-delete
        url: '/votes/' + vote_id
      })
        .success(function(vote) {
          question.togglingVote = undefined;
        })
        .error(function(data, status) {
          question.togglingVote = false;
          question.votes_count++;
          question.vote_id = vote_id;
        });
    } else {
      question.votes_count++;
      question.vote_id = 'voting-in-progress';
      $http.post(question.path + '/votes', null)
        .success(function(vote) {
          question.vote_id = vote.id;
          question.togglingVote = undefined;
        })
        .error(function(data, status) {
          question.togglingVote = false;
          question.vote_id = undefined;
          question.votes_count--;
        });
    }
  };
}
