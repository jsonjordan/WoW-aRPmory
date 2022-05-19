class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:bnet]

  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  def self.from_omniauth(auth)
    unless user = User.find_by(provider: auth.provider, uid: auth.uid)
      user = User.new()
    end
    user.provider = auth.provider
    user.uid = auth.uid
    user.password = Devise.friendly_token[0, 20]
    user.battletag = auth.info.battletag
    user.token = auth.credentials.token
    user.token_expiry = Time.at(auth.credentials.expires_at).to_datetime
    user.bnet_hash = auth.to_h
    user.save!
    user
  end

  def get_characters
    profile = BlizzardApi::Wow.profile(self.token).get
  end
end