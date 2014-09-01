angular.module('autolinker', []).filter('autolinker', function() {
	return function(text) {
		return Autolinker.link(text, { email: false, twitter: false });
	};
});
