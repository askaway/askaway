askaway.controller('CommentsCtrl', ['$scope', function($scope) {
  $scope.submit = function() {
    $scope.new_comment.$setPristine();
  };
}]);

