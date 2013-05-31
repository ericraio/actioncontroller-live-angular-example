require "spec_helper"

describe Users::SessionsController do
  it "should inherit from Devise::SessionsController" do
    Users::SessionsController.superclass.should == Devise::SessionsController
  end

end
