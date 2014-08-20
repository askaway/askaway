askaway.controller( 'QuestionFormCtrl', ['$scope', function( $scope ) {
  $scope.submit = function() {
    $scope.new_question.$setPristine();
  };
}]);
