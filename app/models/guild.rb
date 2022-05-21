class Guild < ApplicationRecord

    validates :uid, presence: true
    validates :name, presence: true

    has_many :characters

    def active_guildies
        self.characters.where(status: 'active')
    end

end