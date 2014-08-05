askaway.controller('AnnouncementsCtrl', ['$scope', '$http', function($scope, $http) {
  $scope.dismissAnnouncement = function() {
    $http.post('announcements/dismiss')
  };
}]);
