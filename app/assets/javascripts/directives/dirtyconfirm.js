askaway.directive('dirtyconfirm', [ '$window', function($window) {
  return {
    link: function($scope, $el, $attrs) {
      var form = $scope[$attrs.dirtyconfirm],
        message = $attrs.dirtyconfirmmessage || "You have unsaved changes.";

      if (!form) {
        return;
      }

      function dirtyForm(e) {
        if (form.$dirty) {
          e.returnValue = e.returnValue || message;
        }
      }

      if ($window.addEventListener) {
        $window.addEventListener('beforeunload', dirtyForm);
      } else if ($window.attachEvent) {
        $window.attachEvent('onbeforeunload', dirtyForm);
      }
      $scope.$on('$locationChangeStart', function(e, next, current) {
        if (form.$dirty && !confirm(message)) {
          e.preventDefault();
        }
      });
    }
  };
} ]);
