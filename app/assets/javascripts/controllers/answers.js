askaway.controller('AnswerFormCtrl', ['$scope', '$http', '$location', '$compile', function($scope, $http, $location, $compile) {
  $scope.addAnswer = function() {
    $http.post(this.question.path + '/answers', {
      answer: {
        body: this.question.answerText
      }
    })
      .success(function(question) {
        $scope.new_answer.$setPristine();
        $scope.question.answers = question.answers;
        $scope.question.answers_count = question.answers_count;
        $scope.question.can_answer = question.can_answer;
        $scope.showShareModal(question);
      })
      .error(function(data, status) {
        if (status === 422) {
          $scope.question.error_message = data.message;
        }
      });
  };
  $scope.submit = function() {
    $scope.new_answer.$setPristine();
  };
  $scope.showShareModal = function (question) {
    var tweetText = "I've just answered this question on @AskAwayNZ"
    $scope.shareUrl = $location.protocol() + '://' + $location.host() + question.path;
    var tweetButton = '<a href="https://twitter.com/share?text='+tweetText+'&url='+encodeURI($scope.shareUrl)+'" class="col-xs-12 btn btn-info btn-lg login-social-btn" target="_blank"><div class="fa fa-twitter login-social-icon fa-fw"></div>Tweet</a>';
    var shareButton = "<facebooksharer></facebooksharer>"
    var shareButtons = "<div class='row'><div class='col-xs-5'>"+tweetButton+"</div><div class='col-xs-5'>"+shareButton+"</div></div>"
    $("#share-answer-modal .modal-body .share-buttons").html($compile(shareButtons)($scope));
    $("#share-answer-modal").modal();
  };
  $scope.shareAnswerOnFacebook = function(shareUrl) {
    FB.ui({
      method: 'share',
      href: $scope.shareUrl,
    }, function(response){});
  }
}]);
