class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  field :title, type: String
  field :publish_date, type: DateTime
  field :url, type: String
  field :gbd_id, type: Integer
  field :overview, type: String
  field :esrb, type: String
  field :players, type: String
  field :cooperative, type: String
  field :publisher, type: String
  field :developer, type: String
  field :release_date, type: DateTime
  field :rating, type: String
  field :youtube_video, type: String
  field :genres, type: String

  validates_presence_of :title
  validates_uniqueness_of :title
  before_save :generate_url
  has_and_belongs_to_many :platforms

  search_in :title

  def to_s
    title
  end

  def generate_url
    self.url = self.title.gsub(/\s+/, "").downcase
  end

  def self.add_game(game)
    created_game = self.create({
      gbd_id: game.gbd_id,
      title: game.title,
      overview: game.overview,
      esrb: game.esrb,
      players: game.players,
      cooperative: game.cooperative,
      publisher: game.publisher,
      developer: game.developer,
      release_date: (game.release_date rescue nil),
      rating: game.rating,
      youtube_video: game.youtube_video,
      genres: game.genres
    })
    if created_game.errors.messages.blank?
      Platform.find_or_create_by(name: game.platform).games << created_game
    end
  end

end
