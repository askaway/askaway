askaway.directive('twittershare', [ '$window', '$timeout', function($window, $timeout) {
  return {
    link: function($scope, $el, $attrs) {
      var delay = 1,
        loc = $window.location;

      function loadShare() {
        if (!$window.twttr) {
          delay *= 2;
          return $timeout(loadShare, delay);
        }
        console.log($el[0].outerHTML);
        $window.twttr.widgets.load($el.parent()[0]);
      }

      angular.element($el).attr({
        href: 'https://twitter.com/share',
        'data-count': 'horizontal',
        'data-text': $attrs.text,
        'data-url': loc.origin + $attrs.path,
        'data-lang': 'en'
      });

      $timeout(loadShare, 10);
    }
  };
} ]);
