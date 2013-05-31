require 'spec_helper'

describe Post do
  before :each do
    @now = Time.now
    Time.stub(:now).and_return(@now)
    @post = Post.new(
      body: "MyString",
      headline: "My Headline",
      slug: "my-headline",
      created_at: @now
    )
  end

  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should have_field(:body).of_type(String) }
  it { should validate_presence_of(:body) }
  it { should have_field(:headline).of_type(String) }
  it { should validate_presence_of(:headline) }
  it { should have_field(:slug).of_type(String) }


  it { should belong_to(:user) }


  describe "#pub_create" do
    it "should publish to redis that a new post has been created at" do
      Redis.any_instance.should_receive(:publish).with('messages.create', @post.created_at)
      @post.pub_create
    end
    it "should not publish to redis if there is no created at value set" do
      Post.any_instance.stub(:created_at).and_return(nil)
      Redis.any_instance.should_not_receive(:publish)
      @post.pub_create
    end
  end

  describe "#to_param" do
    it "should return the slug" do
      @post.to_param.should == 'my-headline'
    end
  end

  describe "#generate_slug" do
    it "should set the url to from the title but with out whitespace and lowercase the url and be memoized" do
      game = Post.new
      game.should_receive(:headline).once.and_return('Breaking News')
      game.generate_slug
      game.generate_slug
      game.slug.should == 'breaking-news'
    end
  end


end
