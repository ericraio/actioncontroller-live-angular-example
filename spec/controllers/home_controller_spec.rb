require "spec_helper"

describe HomeController do
  it "should inherit from ApplicationController" do
    HomeController.superclass.should == ApplicationController
  end

  describe "GET /" do
    it "should render 200 success" do
      get :index
      response.code.should eq('200')
    end
  end
end
