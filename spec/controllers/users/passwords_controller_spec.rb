require "spec_helper"

describe Users::PasswordsController do
  it "should inherit from Devise::PasswordsController" do
  end

    describe "#resource_params (private)" do
      before :each do
        @params = mock('Params')
        @permit_params = mock('PermitParams')
      end
      it "should permit :email, :password, :password_confirmation, :reset_password_token" do
        controller.should_receive(:params).and_return(@params)
        @params.should_receive(:require).with(:user).and_return(@permit_params)
        @permit_params.should_receive(:permit).with(:email, :password, :password_confirmation, :reset_password_token)
        controller.send(:resource_params)
      end
    end
end
