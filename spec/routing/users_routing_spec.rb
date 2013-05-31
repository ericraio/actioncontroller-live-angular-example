require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #show" do
      get("/atrosity").should route_to("users#show", slug: "atrosity")
    end

    it "routes to #follow_user" do
      get('/follow/user/atrosity').should route_to("users#follow_user", slug: "atrosity")
    end

    it "routes to #unfollow_user" do
      get('/unfollow/user/atrosity').should route_to("users#unfollow_user", slug: "atrosity")
    end

    it "routes to #edit_profile" do
      get('/user/profile/edit').should route_to("users#edit_profile")
    end

    it "routes to #update_profile" do
      post('/user/profile/update').should route_to("users#update_profile")
    end

  end
end
