class Character < ApplicationRecord

    validates :uid, presence: true
    validates :name, presence: true
    validates :realm, presence: true

    belongs_to :guild
    belongs_to :user

    has_many :character_guild_connections, foreign_key: :main_character_id
    has_many :guildies, through: :character_guild_connections, source: :guildie

end