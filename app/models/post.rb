class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  validates :body, presence: true

  field :headline, type: String
  validates :headline, presence: true

  field :slug, type: String
  field :user_id

  belongs_to :user, foreign_key: 'user_id'
  before_validation :generate_slug

  after_create :pub_create

  def pub_create
    $redis.publish('messages.create', self.created_at) if self.created_at
  end

  def to_param
    slug
  end

  def generate_slug
    self.slug ||= self.headline.parameterize
  end

end
