askaway.directive('fbshare', [ '$window', '$timeout', function($window, $timeout) {
  return {
    link: function($scope, $el, $attrs) {
      var delay = 1,
        loc = $window.location,
        key;

      function loadShare() {
        if (!$window.fbAsyncInit || !$window.FB) {
          delay *= 2;
          return $timeout(loadShare, delay);
        }

        FB.XFBML.parse($el.parent()[0]);
      }

      angular.element($el).attr({
        'data-layout': 'button_count',
        'data-href': loc.origin + $attrs.path,
        'data-action': 'like',
        'data-show-faces': 'false',
        'data-share': 'false'
      });

      $timeout(loadShare, 10);
    }
  };
} ]);

