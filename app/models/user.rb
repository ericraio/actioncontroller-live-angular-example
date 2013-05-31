class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Paperclip
  include Mongo::Followable::Followed
  include Mongo::Followable::Follower
  include Mongo::Followable::History
  include User::AuthDefinitions

  has_mongoid_attached_file :avatar
  has_mongoid_attached_file :cover_photo

  has_many :identities
  has_many :posts

  field :username, type: String
  field :email, type: String
  field :slug, type: String
  field :avatar, type: String
  field :first_name, type: String
  field :last_name, type: String

  recommends :games, :platforms, :posts

  validates :slug, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
  before_validation :generate_slug

  def generate_slug
    self.slug ||= self.username.parameterize
  end

  def to_s
    username
  end

  def to_param
    slug
  end

  def followees_latest_posts(options = {})
    Post.any_in(user_id: [self.id, self.all_followees.map(&:id)].flatten).order_by('created_at DESC').limit(options[:limit]).skip(options[:offset]).where(options[:where])
  end

  # Password not required when using omniauth
  def password_required?
    super && identities.empty?
  end

end
