class Aggregation::Source::TheGamesDb < Aggregation::AggregationSource

  def self.fetch_records_from_remote
    platforms.each do |platform|
      uri = URI.parse("http://thegamesdb.net/api/GetPlatformGames.php?platform=#{platform[1]}")
      response = Net::HTTP.get_response(uri)
      response_hash = Hash.from_xml(response.body)
      response_hash["Data"]["Game"].each do |g|
        game = TheGamesDB::Game.find(g['id']) rescue next
        ::Game.add_game(game)
      end
    end
  end

  def self.platforms
    [
        ["nes", 7],
        ["snes", 6],
        ["n64", 3],
        ["gcn", 2],
        ["wii", 9],
        ["wiiu", 38],
        ["dmg", 4],
        ["gbc", 41],
        ["gba", 5],
        ["nds", 8],
        ["3ds", 4912],
        ["sms", 25],
        ["smd", 18],
        ["32x", 33],
        ["scd", 21],
        ["stn", 17],
        ["sdc", 16],
        ["sgg", 20],
        ["ps1", 10],
        ["ps2", 11],
        ["ps3", 12],
        ["psp", 13],
        ["psv", 39],
        ["xbox", 14],
        ["x360", 15],
        ["3do", 25],
        ["2600", 22],
        ["5200", 26],
        ["jag", 28],
        ["cvn", 31],
        ["c64", 40],
        ["aes", 24],
        ["pce", 34]
    ]

  end

end
