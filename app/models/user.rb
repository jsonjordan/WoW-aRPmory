class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:bnet]
  
  validates :uid, presence: true
  validates :battletag, presence: true

  has_many :characters

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def display_name
    self.battletag.slice(0...(self.battletag.index('#')))
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
    characters = profile[:wow_accounts].first[:characters]
    characters.each do |char_info|
      unless char = Character.find_by(uid: char_info[:id])
        char = Character.new()
      end
      char.uid = char_info[:id]
      char.name = char_info[:name]
      char.realm = char_info[:realm][:name][:en_US]
      char.user = self
      char.save!
    end
  end
end

# {:character=>{:href=>"https://us.api.blizzard.com/profile/wow/character/scarlet-crusade/scarnn?namespace=profile-us"},
#  :protected_character=>{:href=>"https://us.api.blizzard.com/profile/user/wow/protected-character/126-lu?namespace=profile-us"},
#  :name=>"Scarnn",
#  :id=>174249663,
#  :realm=>
#   {:key=>{:href=>"https://us.api.blizzard.com/data/wow/realm/126?namespace=dynamic-us"},
#    :name=>
#     {:en_US=>"Scarlet Crusade",
#      :es_MX=>"Scarlet Crusade",
#      :pt_BR=>"Scarlet Crusade",
#      :de_DE=>"Scarlet Crusade",
#      :en_GB=>"Scarlet Crusade",
#      :es_ES=>"Scarlet Crusade",
#      :fr_FR=>"Scarlet Crusade",
#      :it_IT=>"Scarlet Crusade",
#      :ru_RU=>"Scarlet Crusade",
#      :ko_KR=>"Scarlet Crusade",
#      :zh_TW=>"血色十字軍",
#      :zh_CN=>"血色十字军"},
#    :id=>126,
#    :slug=>"scarlet-crusade"},
#  :playable_class=>
#   {:key=>{:href=>"https://us.api.blizzard.com/data/wow/playable-class/4?namespace=static-9.1.5_40764-us"},
#    :name=>
#     {:en_US=>"Rogue",
#      :es_MX=>"Pícaro",
#      :pt_BR=>"Ladino",
#      :de_DE=>"Schurke",
#      :en_GB=>"Rogue",
#      :es_ES=>"Pícaro",
#      :fr_FR=>"Voleur",
#      :it_IT=>"Ladro",
#      :ru_RU=>"Разбойник",
#      :ko_KR=>"도적",
#      :zh_TW=>"盜賊",
#      :zh_CN=>"潜行者"},
#    :id=>4},
#  :playable_race=>
#   {:key=>{:href=>"https://us.api.blizzard.com/data/wow/playable-race/27?namespace=static-9.1.5_40764-us"},
#    :name=>
#     {:en_US=>"Nightborne",
#      :es_MX=>"Natonocturno",
#      :pt_BR=>"Filho da Noite",
#      :de_DE=>"Nachtgeborener",
#      :en_GB=>"Nightborne",
#      :es_ES=>"Nocheterna",
#      :fr_FR=>"Sacrenuit",
#      :it_IT=>"Nobile Oscuro",
#      :ru_RU=>"Ночнорожденный",
#      :ko_KR=>"나이트본",
#      :zh_TW=>"夜裔精靈",
#      :zh_CN=>"夜之子"},
#    :id=>27},
#  :gender=>
#   {:type=>"MALE",
#    :name=>
#     {:en_US=>"Male",
#      :es_MX=>"Masculino",
#      :pt_BR=>"Masculino",
#      :de_DE=>"Männlich",
#      :en_GB=>"Male",
#      :es_ES=>"Masculino",
#      :fr_FR=>"Homme",
#      :it_IT=>"Maschio",
#      :ru_RU=>"Мужской",
#      :ko_KR=>"남성",
#      :zh_TW=>"男性",
#      :zh_CN=>"男性"}},
#  :faction=>
#   {:type=>"HORDE",
#    :name=>
#     {:en_US=>"Horde", :es_MX=>"Horda", :pt_BR=>"Horda", :de_DE=>"Horde", :en_GB=>"Horde", :es_ES=>"Horda", :fr_FR=>"Horde", :it_IT=>"Orda", :ru_RU=>"Орда", :ko_KR=>"호드", :zh_TW=>"部落", :zh_CN=>"部落"}}
# ,
#  :level=>10}