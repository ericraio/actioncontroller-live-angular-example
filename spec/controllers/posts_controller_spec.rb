require 'spec_helper'

describe PostsController do
  before :each do
    controller.stub(:authenticate_user!)
    @now = Time.now
    Time.stub(:now).and_return(@now)
  end

  let(:valid_attributes) { { "body" => "MyString","headline" => "MyHeadline" } }
  let(:valid_session) { {} }

  describe "GET show" do
    before :each do
      @post = Post.create! valid_attributes
    end
    describe "before filters" do
      it "should call the set_post before filter" do
        controller.should_receive(:set_post)
        get :show, {:slug => @post.to_param}, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:set_post).ordered
        get :show, {:slug => @post.to_param}, valid_session
      end
    end
    it "assigns the requested post as @post" do
      get :show, {:slug => @post.to_param}, valid_session
      assigns(:post).should eq(@post)
    end
  end

  describe "GET new" do
    before :each do
      @post = mock(Post)
      Post.stub(:new).and_return(@post)
    end
    describe "before filters" do
      it "should call the authenticate user before filter" do
        controller.should_receive(:authenticate_user!)
        get :new, {}, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        get :new, {}, valid_session
      end
    end
    it "should assign a new post to @post" do
      get :new, {}, valid_session
      assigns[:post].should == @post
    end
    it "should render the new template" do
      get :new, {}, valid_session
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    before :each do
      @post = Post.create! valid_attributes
    end
    describe "before filters" do
      it "should call the authenticate user before filter" do
        controller.should_receive(:authenticate_user!)
        get :edit, {:slug => @post.to_param}, valid_session
      end
      it "should call the set_post before filter" do
        controller.should_receive(:set_post)
        get :edit, {:slug => @post.to_param}, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        controller.should_receive(:set_post).ordered
        get :edit, {:slug => @post.to_param}, valid_session
      end
    end
    it "assigns the requested post as @post" do
      get :edit, {:slug => @post.to_param}, valid_session
      assigns(:post).should eq(@post)
    end
  end

  describe "POST create" do
    before :each do
      request.env['HTTP_REFERER'] = 'http://test.com/post/123'
      controller.stub(:current_user)
    end
    describe "before filters" do
      it "should call the authenticate user before filter" do
        controller.should_receive(:authenticate_user!)
        post :create, {:post => valid_attributes}, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        post :create, {:post => valid_attributes}, valid_session
      end
    end

    it "should return the correct content type" do
      post :create, {:post => valid_attributes}, valid_session
      response.headers["Content-Type"].should == "text/javascript"
    end

    describe "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, {:post => valid_attributes}, valid_session
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create, {:post => valid_attributes}, valid_session
        assigns(:post).should be_a(Post)
        assigns(:post).should be_persisted
      end
      it "should set the post to the current user" do
        @user = FactoryGirl.create(:user)
        controller.should_receive(:current_user).and_return(@user)
        post :create, {:post => valid_attributes}, valid_session
        assigns(:post).user.should == @user
      end
      it "should set the flash notice to successful" do
        post :create, {:post => valid_attributes}, valid_session
        flash[:notice].should == 'Post was successfully created.'
      end
      it "redirects to the created post" do
        post :create, {:post => valid_attributes}, valid_session
        response.should redirect_to(Post.last)
      end
      it "redirects to back if on the dashboard" do
        request.env['HTTP_REFERER'] = 'http://test.host/'
        post :create, {:post => valid_attributes}, valid_session
        response.should redirect_to(:back)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        post :create, {:post => { "headline" => "invalid value", "body" => "invalid value" }}, valid_session
        assigns(:post).should be_a_new(Post)
      end
      it "should not publish to redis that a new post has been created at" do
        Post.any_instance.stub(:save).and_return(false)
        Redis.any_instance.should_not_receive(:publish)
        post :create, {:post => { "headline" => "invalid value", "body" => "invalid value" }}, valid_session
      end
      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        post :create, {:post => { "headline" => "invalid value", "body" => "invalid value" }}, valid_session
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    before :each do
      request.env['HTTP_REFERER'] = 'http://test.host/'
    end

    describe "with valid params" do
      it "updates the requested post" do
        post = Post.create! valid_attributes
        # Assuming there are no other posts in the database, this
        # specifies that the Post created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Post.any_instance.should_receive(:update).with({ "body" => "MyString" })
        put :update, {:slug=> post.to_param, :post => { "body" => "MyString" }}, valid_session
      end

      it "assigns the requested post as @post" do
        post = Post.create! valid_attributes
        put :update, {:slug => post.to_param, :post => valid_attributes}, valid_session
        assigns(:post).should eq(post)
      end

      it "redirects to the post" do
        post = Post.create! valid_attributes
        put :update, {:slug => post.to_param, :post => valid_attributes}, valid_session
        response.should redirect_to(post)
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        post = Post.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:update).and_return(false)
        put :update, {:slug => post.to_param, :post => { "body" => "invalid value" }}, valid_session
        assigns(:post).should eq(post)
      end

      it "re-renders the 'edit' template" do
        post = Post.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:update).and_return(false)
        put :update, {:slug => post.to_param, :post => { "body" => "invalid value" }}, valid_session
        response.should redirect_to(:back)
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @post = FactoryGirl.create(:post)
      controller.instance_variable_set(:@post, @post)
    end
    describe "before filters" do
      before :each do
        @post.stub(:destroy)
        controller.stub(:redirect_to)
        controller.stub(:posts_url)
      end
      it "should call the authenticate_user! before filter" do
        controller.should_receive(:authenticate_user!)
        delete :destroy, {:slug => @post.to_param}, valid_session
      end
      it "should call the set_post before filter" do
        controller.should_receive(:set_post)
        delete :destroy, {:slug => @post.to_param}, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        controller.should_receive(:set_post).ordered
        delete :destroy, {:slug => @post.to_param}, valid_session
      end
    end
    it "destroys the requested post" do
      @post.should_receive(:destroy)
      controller.stub(:redirect_to)
      controller.destroy
    end
    it "redirects to the posts list" do
      @post.stub(:destroy)
      controller.should_receive(:redirect_to).with(:back, :notice => 'Post was successfully destroyed.')
      controller.destroy
    end
  end

  describe "GET /posts/feed" do
    before :each do
      @activity_feed = [@post_one, @post_two]
      @user = mock(User)
      controller.stub(:current_user).and_return(@user)
      @user.stub(:followees_latest_posts).and_return(@activity_feed)
    end
    it "should assign the activity feed to @activity_feed" do
      @user.should_receive(:followees_latest_posts).and_return(@activity_feed)
      controller.should_receive(:respond_with).with(@activity_feed)
      get :feed
    end
  end

  describe "POST /posts/:slug/like" do
    before :each do
      @post = FactoryGirl.create(:post)
      @user = mock(User)
      controller.stub(:current_user).and_return(@user)
      @user.stub(:like)
    end
    describe "before filters" do
      it "should call the authenticate_user! before filter" do
        controller.should_receive(:authenticate_user!)
        post :like, {:slug => @post.to_param}, valid_session
      end
      it "should call the set_post before filter" do
        controller.should_receive(:set_post)
        post :like, {:slug => @post.to_param}, valid_session
      end
      it "should call the before filters in order" do
        controller.should_receive(:authenticate_user!).ordered
        controller.should_receive(:set_post).ordered
        post :like, {:slug => @post.to_param}, valid_session
      end
    end
    it "should like the post from the current_user" do
      @user.should_receive(:like).with(@post)
      post :like, {:slug => @post.to_param}, valid_session
    end
    it "should set the content type header " do
      post :like, {:slug => @post.to_param}, valid_session
      response.headers["Content-Type"].should == "text/javascript"
    end
  end

  describe "GET /posts/events" do
    before :each do
      @redis = mock(Redis)
      @logger = mock(Logger)
      @message = mock('Message')
      @user = mock(User)
      Redis.stub(:new).and_return(@redis)
      @redis.stub(:psubscribe)
      @redis.stub(:quit)
      @redis.stub(:psubscribe).with('messages.*').and_yield(@message)
      @message.stub(:pmessage).and_yield('pattern','event', 'data')
      controller.stub(:current_user).and_return(@user)
      @user.stub(:followees_latest_posts).and_return([])
    end
    it "should return if the user isn't logged in" do
      controller.stub(:current_user).and_return(false)
      get :events, {}
      response.headers['Content-Type'].should_not == 'text/event-stream'
    end
    it "should set the content type header to text/event-stream for live streaming" do
      get :events, {}
      response.headers['Content-Type'].should == 'text/event-stream'
    end
    it "should create a new Redis instance for the request" do
      Redis.should_receive(:new)
      get :events, {}
    end
    it "should subscrube to messages.* in redis" do
      @redis.should_receive(:psubscribe).with('messages.*')
      get :events, {}
    end
    it "should check each message that comes in" do
      @message = mock('Message')
      @redis.stub(:psubscribe).with('messages.*').and_yield(@message)
      @message.should_receive(:pmessage)
      get :events, {}
    end
    it "should pull the latest followees post for each message for the current user" do
      controller.should_receive(:current_user).and_return(@user)
      @user.should_receive(:followees_latest_posts).with(where: { :created_at.gte => 'data' }).and_return([])
      get :events, {}
    end
    it "should check if the latest post is there and write to the stream" do
      @post = mock(Post, to_json: "post_json_data" )
      @user.should_receive(:followees_latest_posts).and_return([@post])
      get :events, {}
      response.stream.instance_variable_get(:@buf)[0].should == "event: event\n"
      response.stream.instance_variable_get(:@buf)[1].should == "data: post_json_data\n\n"
    end
    it "should not shit if there is an IOError Exception (caused from user closing the connection)" do
      @redis.stub(:psubscribe).and_raise(IOError)
      controller.stub(:logger).and_return(@logger)
      @logger.should_receive(:info).with("Stream closed")
      get :events, {}
    end
    it "should ensure that redis the response stream closes" do
      @redis.stub(:psubscribe).and_raise(IOError)
      @redis.should_receive(:quit)
      get :events, {}
    end
    it "should ensure that the stream gets closed" do
      @redis.stub(:psubscribe).and_raise(IOError)
      @redis.should_receive(:quit)
      response.stream.closed?.should be_false
      get :events, {}
      response.stream.closed?.should be_true
    end
  end

  describe "#set_post (private)" do
    before :each do
      @params = { slug: 'my-slug' }
      @post = mock(Post)
    end
    it "should find the post from the slug" do
      controller.should_receive(:params).and_return(@params)
      Post.should_receive(:where).with(slug: @params[:slug]).and_return([@post])
      controller.send(:set_post).should == @post
      assigns[:post].should == @post
    end
  end

  describe "#post_params (private)" do
    before :each do
      @params = mock('Params')
      @permit_params = mock('PermitParams')
    end
    it "should permit body, headline" do
      controller.should_receive(:params).and_return(@params)
      @params.should_receive(:require).with(:post).and_return(@permit_params)
      @permit_params.should_receive(:permit).with(:body, :headline)
      controller.send(:post_params)
    end
  end

end
