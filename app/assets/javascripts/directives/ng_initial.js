askaway.directive('ngInitial', function() {
  return {
    restrict: 'A',
    controller: ['$scope', '$element', '$attrs', '$parse', function($scope, $element, $attrs, $parse) {
      var val    = $attrs.sbInitial || $attrs.value || $element.text();
      var getter = $parse($attrs.ngModel);
      var setter = getter.assign;
      setter($scope, val);
    }]
  };
});
