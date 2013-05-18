require "spec_helper"

describe Users::RegistrationsController do
  it "should inherit from ApplicationController" do
    Users::RegistrationsController.superclass.should == Devise::RegistrationsController
  end

  describe "#update" do
    pending
  end

  %w{sign_up_params account_update_params}.each do |method|
    describe "##{method} (private)" do
      before :each do
        @params = mock('Params')
        @permit_params = mock('PermitParams')
      end
      it "should permit first_name, last_name, email, password, password_confirmation, current_password" do
        controller.should_receive(:params).and_return(@params)
        @params.should_receive(:require).with(:user).and_return(@permit_params)
        @permit_params.should_receive(:permit).with(:username, :first_name, :last_name, :email, :password, :password_confirmation, :current_password)
        controller.send(method.to_sym)
      end
    end
  end

end
