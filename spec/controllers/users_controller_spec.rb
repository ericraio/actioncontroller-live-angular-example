require 'spec_helper'

def valid_params
  {slug: 'atrosity'}
end

describe UsersController do

  describe "GET 'show'" do
    before :each do
      controller.stub(:set_user)
    end
    describe "before filters" do
      it "should receive the set_user before filter" do
        controller.should_receive(:set_user)
        get 'show', valid_params
      end
      it "should call the before filters in order" do
        controller.should_receive(:set_user).ordered
        get 'show', valid_params
      end
    end
    it "returns http success" do
      get 'show', valid_params
      response.should be_success
    end
  end

  describe "POST /user/profile/update" do
    before :each do
      controller.stub(:authenticate_user!)
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      @user = mock(User)
      @user.stub(:update_attributes)
      controller.stub(:request).and_return(@request)
      controller.stub(:current_user).and_return(@user)
      controller.stub(:profile_update_params)
    end
    describe "before filters" do
      it "should call authenticate_user! before filter" do
        controller.should_receive(:authenticate_user!)
        post :update_profile
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        post :update_profile
      end
    end
    it "should update the attributes for the current user" do
      controller.should_receive(:profile_update_params).and_return('params')
      @user.should_receive(:update_attributes).with('params')
      post :update_profile
    end
    it "it should set the flash notice if the user was updated successfully" do
      @user.stub(:update_attributes).and_return(true)
      post :update_profile
      flash[:notice].should == 'Successfully updated your profile.'
    end
    it "should redirect to back to the site" do
      controller.should_receive(:redirect_to).with(:back)
      controller.update_profile
    end
  end

  describe "GET /user/profile/edit" do
    before :each do
      controller.stub(:authenticate_user!)
    end
    describe "before filters" do
      it "should call authenticate_user! before filter" do
        controller.should_receive(:authenticate_user!)
        get :edit_profile
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        get :edit_profile
      end
    end
  end

  describe "GET /follow/user/:slug" do
    before :each do
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      @user = mock(User)
      @current_user = mock(User)
      controller.instance_variable_set(:@user, @user)
      controller.stub(:current_user)
    end
    describe "before filters" do
      it "should receive the set_user before filter" do
        controller.should_receive(:set_user)
        get :follow_user, valid_params
      end
      it "should call the before filters in order" do
        controller.should_receive(:set_user).ordered
        get :follow_user, valid_params
      end
    end
    it "should follow the user" do
      controller.stub(:current_user).and_return(@current_user)
      @current_user.should_receive(:follow).with(@user)
      get :follow_user, valid_params
    end
    it "should redirect to back" do
      controller.should_receive(:redirect_to).with(:back)
      controller.follow_user
    end
  end

  describe "GET /follow/user/:slug" do
    before :each do
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      @user = mock(User)
      @current_user = mock(User)
      controller.instance_variable_set(:@user, @user)
      controller.stub(:current_user)
    end
    describe "before filters" do
      it "should receive the set_user before filter" do
        controller.should_receive(:set_user)
        get :unfollow_user, valid_params
      end
      it "should call the before filters in order" do
        controller.should_receive(:set_user).ordered
        get :unfollow_user, valid_params
      end
    end
    it "should follow the user" do
      controller.stub(:current_user).and_return(@current_user)
      @current_user.should_receive(:unfollow).with(@user)
      get :unfollow_user, valid_params
    end
    it "should redirect to back" do
      controller.should_receive(:redirect_to).with(:back)
      controller.unfollow_user
    end
  end

  describe "set_user (private)" do
    before :each do
      @params = {slug: 'atrosity'}
      @user = mock(User)
    end
    it "should look up the user and memoize the user" do
      controller.should_receive(:params).and_return(@params)
      User.should_receive(:where).once.with(slug: @params[:slug]).and_return([@user])
      controller.send(:set_user)
      controller.send(:set_user)
      assigns[:user].should == @user
    end
    it "should return 404 Not Found if the user doesn't exist" do
      controller.should_receive(:params).and_return(@params)
      User.should_receive(:where).with(slug: @params[:slug]).and_return([])
      controller.should_receive(:redirect_to).with(status: 404)
      controller.send(:set_user).should be_nil
    end
  end

    describe "#profile_update_params (private)" do
      before :each do
        @params = mock('Params')
      end
      it "should permit avatar" do
        controller.should_receive(:params).and_return(@params)
        @params.should_receive(:permit).with(:avatar, :cover_photo)
        controller.send(:profile_update_params)
      end
    end

end
