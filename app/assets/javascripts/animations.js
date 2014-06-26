// To use: add .slide-down.ng-hide to an element.
// When ng-hide is removed the element will slide down.
askaway.animation('.slide-down', function() {
  return {
    beforeRemoveClass : function(element, className, done) {
      if(className == 'ng-hide') {
        $(element).css('display', 'none');
      }
      done();
    },

    removeClass : function(element, className, done) {
      if(className == 'ng-hide') {
        $(element).slideDown(150, done);
      }
    },

    beforeAddClass : function(element, className, done) {
      if(className == 'ng-hide') {
        $(element).slideUp(150, done);
      }
    }
  };
});
