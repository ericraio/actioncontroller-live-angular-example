class Platform
  include Mongoid::Document
  field :name, type: String
  field :release_date, type: DateTime
  has_and_belongs_to_many :games
end
