require "spec_helper"

describe HomeController do
  it "should inherit from ApplicationController" do
    HomeController.superclass.should == ApplicationController
  end

  describe "GET /" do
    it "should render the dashboard action if the user is signed in" do
      controller.should_receive(:signed_in?).and_return(true)
      controller.should_receive(:render).with(action: 'dashboard')
      controller.index
    end
    it "should not render the dashboard action if the user is not signed in" do
      controller.should_receive(:signed_in?).and_return(false)
      controller.should_not_receive(:render)
      controller.index
    end
    it "should render 200 success" do
      get :index
      response.code.should eq('200')
    end
  end
end
