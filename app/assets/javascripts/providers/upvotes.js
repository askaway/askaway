askaway.provider('upvotes', function UpvotesProvider() {
  this.$get = [ '$http', function($http) {
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
  }];
});
