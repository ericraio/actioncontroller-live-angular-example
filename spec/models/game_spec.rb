require "spec_helper"

def valid_attributes
  {
    title: 'Zelda'
  }
end

describe Game do
  before :each do
    @game = Game.new(valid_attributes)
  end
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:title).of_type(String) }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:gbd_id).of_type(Integer) }
  it { should have_field(:overview).of_type(String) }
  it { should have_field(:esrb).of_type(String) }
  it { should have_field(:players).of_type(String) }
  it { should have_field(:cooperative).of_type(String) }
  it { should have_field(:publisher).of_type(String) }
  it { should have_field(:developer).of_type(String) }
  it { should have_field(:release_date).of_type(DateTime) }
  it { should have_field(:rating).of_type(String) }
  it { should have_field(:youtube_video).of_type(String) }
  it { should have_field(:genres).of_type(String) }
  it { should have_and_belong_to_many(:platforms) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }

  it "should include the module Mongoid::Search" do
    Game.included_modules.should include(Mongoid::Search)
  end

  describe "#to_s" do
    it "should return the title" do
      @game.to_s.should == 'Zelda'
    end
  end

  describe "#generate_url" do
    it "should set the url to from the title but with out whitespace and lowercase the url" do
      game = Game.new(title: 'World of Warcraft')
      game.generate_url
      game.url.should == 'worldofwarcraft'
    end
  end

  describe "search_in" do
    pending
    #it { Game.received_message?(:search_in).should be_true }
  end

  describe "#self.add_game(game)" do
    before :each do
      @attributes = {
        gbd_id: '123',
        title: 'Zelda',
        overview: 'overview',
        esrb: 'M',
        players: '1',
        cooperative: 'yes',
        publisher: 'Nintendo',
        developer: 'Nintendo',
        release_date: '2001',
        rating: '4',
        youtube_video: 'youtube',
        genres: 'roleplaying'
      }
      @game = mock(Game, @attributes.merge({ platform: 'Nintendo 64' }))
    end
    it "should create the game" do
      Game.should_receive(:create).with(@attributes).and_return(mock(Game, :errors => mock('Messages', :messages => true)))
      Game.add_game(@game).should be_nil
    end
    it "should not shit if release date fails" do
      @game.stub(:release_date).and_raise(StandardError)
      Game.should_receive(:create).with({
        gbd_id: @game.gbd_id,
        title: @game.title,
        overview: @game.overview,
        esrb: @game.esrb,
        players: @game.players,
        cooperative: @game.cooperative,
        publisher: @game.publisher,
        developer: @game.developer,
        release_date: nil,
        rating: @game.rating,
        youtube_video: @game.youtube_video,
        genres: @game.genres
      }).and_return(mock(Game, :errors => mock('Messages', :messages => true)))
      Game.add_game(@game).should be_nil
    end
    it "should find or create the platform from the " do
      created_game = mock(Game, :errors => mock('Messages', :messages => ''))
      Game.should_receive(:create).with(@attributes).and_return(created_game)
      Platform.should_receive(:find_or_create_by).with(name: @game.platform).and_return(mock('Games', games: []))
      Game.add_game(@game).should == [created_game]
    end
  end
end
