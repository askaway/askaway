askaway.directive('charcounter', function() {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      content: '=forModel',
      maxlength: '=maxlength'
    },
    template: "<div class='char-counter'>{{maxlength - content.length}}{{console.log($scope, content)}}</div>"
  };
});
