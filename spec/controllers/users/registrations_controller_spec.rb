require "spec_helper"

describe Users::RegistrationsController do
  it "should inherit from ApplicationController" do
    Users::RegistrationsController.superclass.should == Devise::RegistrationsController
  end

  describe "#update" do
    before :each do
      @params = { user: {} }
      @user = mock(User, :id => 1)
      controller.stub(:params).and_return(@params)
      controller.stub(:current_user).and_return(@user)
      controller.stub(:render)
      User.stub(:find)
    end
    it "should find the user from the current user's id" do
      User.should_receive(:find).with(1)
      controller.update
    end
    it "should update the user's attributes" do
      User.should_receive(:find).and_return(@user)
      controller.should_receive(:account_update_params).and_return('params')
      @user.should_receive(:update_attributes).with('params')
      controller.update
    end
    it "should set the flash message, sign in the user and redirect the user if the attributes are updated" do
      User.should_receive(:find).and_return(@user)
      controller.should_receive(:account_update_params).and_return('params')
      @user.should_receive(:update_attributes).with('params').and_return(true)
      controller.should_receive(:set_flash_message).with(:notice, :updated)
      controller.should_receive(:sign_in).with(@user, :bypass => true)
      controller.should_receive(:after_update_path_for).with(@user).and_return('after_update_path')
      controller.should_receive(:redirect_to).with('after_update_path')
      controller.update
    end
    it "should render the edit view if the params can't update" do
      User.should_receive(:find).and_return(@user)
      controller.should_receive(:account_update_params).and_return('params')
      @user.should_receive(:update_attributes).with('params').and_return(false)
      controller.should_receive(:render).with('edit').and_return('redirected')
      controller.update.should == 'redirected'
    end
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
