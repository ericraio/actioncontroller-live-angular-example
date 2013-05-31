require "spec_helper"

describe PostsController do
  describe "routing" do

    it "routes to #new" do
      get("/posts/new").should route_to("posts#new")
    end

    it "routes to #show" do
      get("/posts/headline").should route_to("posts#show", :slug => "headline")
    end

    it "routes to #edit" do
      get("/posts/headline/edit").should route_to("posts#edit", :slug => "headline")
    end

    it "routes to #create" do
      post("/posts").should route_to("posts#create")
    end

    it "routes to #update" do
      put("/posts/headline").should route_to("posts#update", :slug => "headline")
    end

    it "routes to #destroy" do
      delete("/posts/headline").should route_to("posts#destroy", :slug => "headline")
    end

    it "routes to #like" do
      post("/posts/headline/like").should route_to("posts#like", :slug => "headline")
    end

    it "routes to #feed" do
      get("/posts/feed").should route_to("posts#feed")
    end

  end
end
