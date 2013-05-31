require "spec_helper"

describe User do
  before :each do
    @user = User.new(id: 1, username: 'Lord Atrosity', slug: 'lord-atrosity', email: 'example@gmail.com')
  end
  it "should include the module Mongoid::Search" do
    User.included_modules.should include(Mongoid::Search)
  end
  it "should include the module Mongo::Followable::Followed" do
    User.included_modules.should include(Mongo::Followable::Followed)
  end
  it "should include the module Mongo::Followable::Follower" do
    User.included_modules.should include(Mongo::Followable::Follower)
  end
  it "should include the module Mongo::Followable::History" do
    User.included_modules.should include(Mongo::Followable::History)
  end
  it "should include the module User::AuthDefinitions" do
    User.included_modules.should include(User::AuthDefinitions)
  end

  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:username).of_type(String) }
  it { should have_field(:slug).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:avatar).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:slug) }

  it { should have_many(:identities) }
  it { should have_many(:posts) }

  describe "#generate_slug" do
    it "should set the url to from the username but with out whitespace and lowercase the url" do
      game = User.new(username: 'Lord Atrosity')
      game.generate_slug
      game.slug.should == 'lord-atrosity'
    end
  end

  describe "#to_s" do
    it "should return the username" do
      user = User.new(username: 'Atrosity')
      user.should_receive(:username).and_return('Atrosity')
      user.to_s.should == 'Atrosity'
    end
  end

  describe "#to_param" do
    it "should return the slug" do
      @user.should_receive(:slug).and_return('lord-atrosity')
      @user.to_param.should == 'lord-atrosity'
    end
  end

  describe "#followees_latest_posts(options = {})" do
    before :each do
      @posts = [mock(Post)]
    end
    it "should search for recent posts from my friends and I offset by N" do
      @user.stub(:all_followees).and_return([mock(User, id: 2), mock(User, id: 3)])
      Post.should_receive(:any_in).with(user_id: [1, 2, 3]).and_return(@posts)
      @posts.should_receive(:order_by).with('created_at DESC').and_return(@posts)
      @posts.should_receive(:limit).with(25).and_return(@posts)
      @posts.should_receive(:skip).with(20).and_return(@posts)
      @posts.should_receive(:where).with({ created_at: 'now' }).and_return(@posts)
      @user.followees_latest_posts(offset: 20, limit: 25, where: { created_at: 'now' }).should == @posts
    end
  end

  describe "#password_required?" do
    it "should return true if super returns true and identities are empty" do
      @user.password_required?.should be_true
    end
    it "should return false if there is an identity" do
      @user.should_receive(:identities).and_return([mock(Identity)])
      @user.password_required?.should be_false
    end
  end

end

