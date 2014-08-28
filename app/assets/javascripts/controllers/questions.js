askaway.controller('QuestionsCtrl', [
  '$scope',
  '$http',
  'upvotes',
  function( $scope, $http, upvotes ) {
    $scope.loadingQuestions = false;
    $scope.questionsInitialized = false;
    $scope.questionList = [];
    $scope.page = 1;

    $scope.toggleVote = upvotes;

    $scope.shareQuestion = function(e, question) {
      var shareSelector = "#share-question-" + question.id,
        twitterSelector = "#share-question-btn-twitter-" + question.id,
        facebookSelector = "#share-question-btn-facebook-" + question.id,
        questionUrl = window.location.origin + question.path,
        twitterLink,
        facebookLink;

      if (question.sharesLoaded !== true) {
        twitterLink = '<a href="https://twitter.com/share" class="twitter-share-button" data-text=" " data-url="' + questionUrl + '" data-lang="en">Tweet</a>';
        facebookLink = '<div class="fb-like" data-href="' + questionUrl + '" data-layout="button_count" data-action="like" data-show-faces="false" data-share="false"></div>';
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

      if (window.getSelection && window.getSelection().toString() !== '') {
        return;
      }

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
      var resource = window.location.pathname,
        args = "&" + window.location.search.replace("?", "");

      if (resource === '/') {
        resource = '/trending';
      }

      return (resource + '.json?page=' + $scope.page++ + args);
    }
}]);
