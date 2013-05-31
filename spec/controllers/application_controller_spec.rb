require 'spec_helper'

describe ApplicationController do

  it "should inherit from ActionController::Base" do
    ApplicationController.superclass.should eq(ActionController::Base)
  end

  describe "#configure_permitted_parameters (protected)" do
    it "should permit user parameters" do
      @object = mock('Object')
      @user = mock(User)
      controller.should_receive(:devise_parameter_sanitizer).and_return(@object)
      @object.should_receive(:for).with(:sign_in).and_yield(@user)
      @user.should_receive(:permit).with(:email, :password, :remember_me)
      controller.send(:configure_permitted_parameters)
    end
  end

end
