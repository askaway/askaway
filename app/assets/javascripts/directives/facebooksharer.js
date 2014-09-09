askaway.directive('facebooksharer', function() {
  return {
    restrict: 'E',
    replace: true,
    template: "<a href='' ng-click='shareAnswerOnFacebook()' class='col-xs-12 btn btn-primary btn-facebook btn-lg login-social-btn'><div class='fa fa-facebook login-social-icon fa-fw'></div>Share</a>"
  };
});

