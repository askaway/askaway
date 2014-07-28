askaway.factory('askaway.auth_interceptor', ['$q', function($q) {
  return {
    responseError: function(rejection) {
      if (rejection.status === 401 || rejection.data.require_login) {
        $('#login-modal').modal('show');
      }

      return $q.reject(rejection);
    }
  };
}]);
