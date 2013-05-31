angular.module("posts", ["ngResource"]).
  factory("Post", ['$resource', function($resource) {
    var Post;
    Post = $resource("/posts/:id", 
    { id: "@id" }, 
    {
      update: { method: "PUT" },
      destroy: { method: "DELETE" }
    });

    Post.prototype.destroy = function(cb) {
      return Post.remove({
        id: this.id
      }, cb);
    };

    return Post;
  }
]);
