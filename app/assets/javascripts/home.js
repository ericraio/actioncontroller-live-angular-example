app.factory('ActivityFeed', function($resource) {
  return $resource("/posts/feed");
});

function HomeDashboardCtrl($scope, ActivityFeed, $http) {
  $scope.activityFeed = ActivityFeed.query();

  var eventHandler = function(msg) {
    $scope.$apply(function() {
      $scope.activityFeed.unshift(JSON.parse(msg.data));
    });
  };

  var events_source = new EventSource('/posts/events');
  events_source.addEventListener('messages.create', eventHandler);

  $scope.sendLike = function(slug) {
    $http.post("/posts/" + slug + "/like", {});
  }
};
