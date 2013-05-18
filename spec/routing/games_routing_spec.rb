require "spec_helper"

describe GamesController do
  describe "routing" do

    it "routes to #show" do
      get("/game/Zelda").should route_to("games#show", :title => "Zelda")
    end

  end
end
