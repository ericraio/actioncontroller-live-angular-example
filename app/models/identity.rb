class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, index: true

  field :uid, type: String
  field :provider, type: String
  field :token, type: String
  field :secret, type: String
  field :expires_at, type: DateTime

  field :email, type: String
  field :image, type: String
  field :nickname, type: String
  field :first_name, type: String
  field :last_name, type: String

  index({ uid: 1, provider: 1 }, { unique: true })

  def self.from_omniauth(auth)
    identity = where(auth.slice(:provider, :uid)).first_or_create do |i|
      i.provider     = auth.provider
      i.uid          = auth.uid
      i.token        = auth.credentials.token
      i.secret       = auth.credentials.secret if auth.credentials.secret
      i.expires_at   = auth.credentials.expires_at if auth.credentials.expires_at
      i.email        = auth.info.email if auth.info.email
      i.image        = auth.info.image if auth.info.image
      i.nickname     = auth.info.nickname
      i.first_name   = auth.info.first_name
      i.last_name    = auth.info.last_name
    end
    identity.save!

    if !identity.persisted?
      redirect_to root_url, alert: "Something went wrong, please try again."
    end
    identity
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name
    "#{first_name.capitalize} #{last_name[0].upcase}."
  end

  def find_or_create_user(current_user)
    if current_user && self.user == current_user
      # User logged in and the identity is associated with the current user
      return self.user
    elsif current_user && self.user != current_user
      # User logged in and the identity is not associated with the current user
      # so lets associate the identity and update missing info
      self.user = current_user
      self.user.email       = self.email
      self.user.avatar      = self.image
      self.user.first_name  = self.first_name
      self.user.last_name   = self.last_name
      self.user.save!
      self.save!
      return self.user
    elsif self.user.present?
      # User not logged in and we found the identity associated with user
      # so let's just log them in here
      return self.user
    else
      # No user associated with the identity so we need to create a new one
      self.build_user(
        email: self.email,
        avatar: self.image,
        first_name: self.first_name,
        last_name: self.last_name
      )
      self.user.save!(validate: false)
      self.save!
      return self.user
    end
  end

end
