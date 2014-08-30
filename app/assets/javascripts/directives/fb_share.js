askaway.directive('fbshare', [ '$window', '$timeout', function($window, $timeout) {
  return {
    link: function($scope, $el, $attrs) {
      var delay = 1,
        loc = $window.location,
        key;

      function loadShare() {
        if (!$window.FB || !$window.FB.initCalled) {
          delay *= 2;
          return $timeout(loadShare, delay);
        }

        FB.XFBML.parse($el[0]);
      }

      angular.element($el).attr({
        'data-layout': 'button_count',
        'data-href': 'http://askaway.org.nz' + $attrs.path,
        'data-action': 'like',
        'data-show-faces': 'false',
        'data-share': 'false'
      });

      $timeout(loadShare, 10);
    }
  };
} ]);

