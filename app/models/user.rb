class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongo::Followable::Followed
  include Mongo::Followable::Follower
  include Mongo::Followable::History 
  include User::AuthDefinitions
  include User::Roles

  has_many :identities

  field :username, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :image, type: String
  field :roles_mask, type: Integer

  recommends :games, :platforms

  validates_presence_of :email

  def full_name
    "#{first_name} #{last_name}"
  end

  def name
    "#{first_name.capitalize} #{last_name[0].upcase}."
  end

end
