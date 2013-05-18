require "spec_helper"

describe Aggregation::Source::TheGamesDb do
# def self.fetch_records_from_remote
#   platforms.each do |platform|
#     uri = URI.parse("http://thegamesdb.net/api/GetPlatformGames.php?platform=#{platform[1]}")
#     response = Net::HTTP.get_response(uri)
#     response_hash = Hash.from_xml(response.body)
#     response_hash["Data"]["Game"].each do |game|
#       ::Game.add_game(TheGamesDB::Game.find(game['id'])) rescue next
#     end
#   end
# end

  describe "#self.fetch_records_from_remote" do
    before :each do
      @game_one = mock(Game)
      @game_two = mock(Game)
      @response_one = mock('response', body: 'body')
      @response_two = mock('response', body: 'body')
    end
    it "it should add all the games into the db" do
      Aggregation::Source::TheGamesDb.should_receive(:platforms).and_return([["nes", 7], ["snes", 6]])
      URI.should_receive(:parse).with('http://thegamesdb.net/api/GetPlatformGames.php?platform=7').and_return('url1')
      URI.should_receive(:parse).with('http://thegamesdb.net/api/GetPlatformGames.php?platform=6').and_return('url2')
      Net::HTTP.should_receive(:get_response).with('url1').and_return(@response_one)
      Net::HTTP.should_receive(:get_response).with('url2').and_return(@response_two)
      Hash.should_receive(:from_xml).with(@response_one.body).and_return({ "Data" => { "Game" => [{ "id" => 1 }] } })
      Hash.should_receive(:from_xml).with(@response_two.body).and_return({ "Data" => { "Game" => [{ "id" => 2 }] } })
      TheGamesDB::Game.should_receive(:find).with(1).and_return(@game_one)
      TheGamesDB::Game.should_receive(:find).with(2).and_return(@game_two)
      Game.should_receive(:add_game).with(@game_one)
      Game.should_receive(:add_game).with(@game_two)
      Aggregation::Source::TheGamesDb.fetch_records_from_remote
    end
    it "should skip to the next record if finding the game fails" do
      Aggregation::Source::TheGamesDb.should_receive(:platforms).and_return([["nes", 7], ["snes", 6]])
      URI.should_receive(:parse).with('http://thegamesdb.net/api/GetPlatformGames.php?platform=7').and_return('url1')
      URI.should_receive(:parse).with('http://thegamesdb.net/api/GetPlatformGames.php?platform=6').and_return('url2')
      Net::HTTP.should_receive(:get_response).with('url1').and_return(@response_one)
      Net::HTTP.should_receive(:get_response).with('url2').and_return(@response_two)
      Hash.should_receive(:from_xml).with(@response_one.body).and_return({ "Data" => { "Game" => [{ "id" => 1 }] } })
      Hash.should_receive(:from_xml).with(@response_two.body).and_return({ "Data" => { "Game" => [{ "id" => 2 }] } })
      TheGamesDB::Game.should_receive(:find).with(1).and_raise(StandardError)
      TheGamesDB::Game.should_receive(:find).with(2).and_return(@game_two)
      Game.should_not_receive(:add_game).with(@game_one)
      Game.should_receive(:add_game).with(@game_two)
      Aggregation::Source::TheGamesDb.fetch_records_from_remote
    end
  end

  describe "#self.platforms" do
    it "should return an array of platforms" do
      expected = [ ["nes", 7], ["snes", 6], ["n64", 3], ["gcn", 2], ["wii", 9], ["wiiu", 38], ["dmg", 4], ["gbc", 41], ["gba", 5], ["nds", 8], ["3ds", 4912], ["sms", 25], ["smd", 18], ["32x", 33], ["scd", 21], ["stn", 17], ["sdc", 16], ["sgg", 20], ["ps1", 10], ["ps2", 11], ["ps3", 12], ["psp", 13], ["psv", 39], ["xbox", 14], ["x360", 15], ["3do", 25], ["2600", 22], ["5200", 26], ["jag", 28], ["cvn", 31], ["c64", 40], ["aes", 24], ["pce", 34] ]
      Aggregation::Source::TheGamesDb.platforms.should == expected
    end
  end

end
