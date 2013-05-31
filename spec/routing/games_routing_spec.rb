require "spec_helper"

describe GamesController do
  describe "routing" do

    it "routes to #show" do
      get("/game/zelda").should route_to("games#show", :slug => "zelda")
    end

  end
end
