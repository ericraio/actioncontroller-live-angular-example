require 'spec_helper'

describe GamesController do
  it "should inherit from ApplicationController" do
    GamesController.superclass.should == ApplicationController
  end

  let(:valid_attributes) { { "slug" => "Zelda", "title" => "Zelda" } }

  let(:valid_session) { {} }

  describe "GET show" do
    before :each do
      @game = Game.create! valid_attributes
    end
    describe "before filters"do
      it "should get the set_game before filter" do
        controller.should_receive(:set_game)
        get :show, {:slug => @game.slug }, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:set_game).ordered
        get :show, {:slug => @game.slug }, valid_session
      end
    end
    it "assigns the requested game as @game" do
      get :show, {:slug => @game.slug }, valid_session
      assigns(:game).should eq(@game)
    end
  end

end
