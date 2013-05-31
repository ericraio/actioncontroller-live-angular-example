require "spec_helper"

describe Users::OmniauthCallbacksController do
  it "should in herit from Devise::OmniauthCallbacksController" do
    Users::OmniauthCallbacksController.superclass.should == Devise::OmniauthCallbacksController
  end

  describe "#all" do
    before :each do
      @request = mock('Request', env: { "omniauth.auth" => true })
      @user = mock(User, valid?: nil)
      @flash = mock('Flash')
      @identity = mock(Identity)
      @flash.stub(:notice=)
      @identity.stub(:find_or_create_user).and_return(@user)
      Identity.stub(:from_omniauth).and_return(@identity)
      controller.stub(:request).and_return(@request)
      controller.stub(:current_user).and_return(@user)
      controller.stub(:flash).and_return(@flash)
      controller.stub(:sign_in_and_redirect)
      controller.stub(:sign_in)
      controller.stub(:redirect_to)
      controller.stub(:edit_user_registration_url)
    end
    it "should find the identity" do
      controller.should_receive(:request).twice.and_return(@request)
      Identity.should_receive(:from_omniauth).twice.with(@request.env["omniauth.auth"]).and_return(@identity)
      controller.facebook
      controller.twitter
    end
    it "should find find or create the user from the identity" do
      @identity.should_receive(:find_or_create_user).twice
      controller.facebook
      controller.twitter
    end
    it "should check if the user is valid" do
      @user.should_receive(:valid?).twice
      controller.facebook
      controller.twitter
    end
    it "should render a flash notice, sign in the user and redirect if the user is valid" do
      @user.stub(:valid?).and_return(true)
      @flash.should_receive(:notice=).twice.with("Signed in!")
      controller.should_receive(:sign_in_and_redirect).twice.with(@user)
      controller.facebook
      controller.twitter
    end
    it "should sign in the user and redirect the user to edit the user screen" do
      @user.stub(:valid?).and_return(false)
      controller.should_receive(:sign_in).twice.with(@user)
      controller.should_receive(:edit_user_registration_url).twice.and_return('url')
      controller.should_receive(:redirect_to).twice.with('url')
      controller.facebook
      controller.twitter
    end
  end

end
