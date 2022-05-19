class Guild < ApplicationRecord

    validates :uid, presence: true
    validates :name, presence: true

    has_many :characters

end