class Character < ApplicationRecord

    validates :uid, presence: true
    validates :name, presence: true

    belongs_to :guild
    belongs_to :user
    belongs_to :realm

    has_many :character_images
    has_many :guild_members, :through => :guild, source: :characters

    def guildies
        self.guild_members.where(status: 'active').where.not(id: self.id)
    end

    def inset_image_url
        if self.character_images.where(catagory: 'inset').where(status: 'active')&.first&.url
            self.character_images.where(catagory: 'inset').where(status: 'active').first.url
        else
            '/inset_image_unavailable.png'
        end
    end

    def avatar_image_url
        self.character_images.where(catagory: 'avatar').where(status: 'active').first.url
    end

    def main_image_url
        self.character_images.where(catagory: 'main').where(status: 'active').first.url
    end

    def main_raw_image_url
        self.character_images.where(catagory: 'main-raw').where(status: 'active').first.url
    end

    def set_active_inset_image(character_image_id)
        self.character_images.where(catagory: 'inset').update_all(status: 'inactive')
        if ci = self.character_images.where(catagory: 'inset').find(character_image_id)
            ci.status = 'active'
            ci.save!
        end
    end

    def set_active_avatar_image(character_image_id)
        self.character_images.where(catagory: 'avatar').update_all(status: 'inactive')
        if ci = self.character_images.where(catagory: 'avatar').find_by(character_image_id)
            ci.status = 'active'
            ci.save!
        end
    end

    def set_active_main_image(character_image_id)
        self.character_images.where(catagory: 'main').update_all(status: 'inactive')
        if ci = self.character_images.where(catagory: 'main').find_by(character_image_id)
            ci.status = 'active'
            ci.save!
        end
    end

    def set_active_main_raw_image(character_image_id)
        self.character_images.where(catagory: 'main_raw').update_all(status: 'inactive')
        if ci = self.character_images.where(catagory: 'main_raw').find_by(character_image_id)
            ci.status = 'active'
            ci.save!
        end
    end

    def save_current_images(types_array)
        SaveCurrentImagesWorker.perform_async(self.uid, types_array)
    end

    def converted_money_string
        money_hash = self.converted_money.deep_symbolize_keys
        "#{money_hash[:gold]}g <img src='public/Gold.png'> #{money_hash[:silver]} <img src='public/Silver.png'> #{money_hash[:copper]} <img src='public/Copper.png'>"
    end

    def convert_money
        places = []
        seperated_money = Hash.new
        raw_money = self.money
        until raw_money.zero?
            raw_money, r = raw_money.divmod(10)
            places.unshift(r)
        end
        seperated_money[:copper] = places.pop(3).join('').to_i
        seperated_money[:silver] = places.pop(3).join('').to_i
        seperated_money[:gold] = places.join('').to_i
        seperated_money
    end

    def self.get_user_characters(user)
        profile = BlizzardApi::Wow.profile(user.token).get
        characters = profile[:wow_accounts].first[:characters]
    
        characters.each do |char_info|
            unless char = Character.find_by(uid: char_info[:id])
                char = Character.new()
                char.status = 'disabled'
            end
    
            unless realm = Realm.find_by(uid: char_info[:realm][:id])
                realm = Realm.new()
                realm.uid = char_info[:realm][:id]
                realm.name = char_info[:realm][:name][:en_US]
                realm.slug = char_info[:realm][:slug]
                realm.save!
            end
    
            char.uid = char_info[:id]
            char.name = char_info[:name]
            char.klass = char_info[:playable_class][:name][:en_US]
            char.level = char_info[:level]
            char.realm = realm
            char.user = user

            char.save!
        end
    end

    def initialize_with_deep_update
        UpdateCharacterProfileWorker.perform_async(self.uid)
        UpdateCharacterStatsWorker.perform_async(self.uid)
        UpdateProtectedStatsWorker.perform_async(self.uid)
        InitializeCharacterImageWorker.perform_async(self.uid)
    end

    def deep_update
        UpdateCharacterProfileWorker.perform_async(self.uid)
        UpdateCharacterStatsWorker.perform_async(self.uid)
        UpdateProtectedStatsWorker.perform_async(self.uid)
        UpdateCharacterImageWorker.perform_async(self.uid)
    end
    

    # On Character model, add save image methods for each image type (saves todays image for later use). add set methods for each image type (makes given image only active of its type)


    # def get_protected_character_info
    #     resp = HTTParty.get("https://us.api.blizzard.com/profile/user/wow/protected-character/#{self.realm.uid}-#{self.uid}", :query => {
    #         'namespace' => 'profile-us',
    #         'locale' => 'en_US',
    #         'access_token' => self.user.token,
    #     })
    #     resp.deep_symbolize_keys
    # end

    # def get_character_stats
    #     resp = HTTParty.get("https://us.api.blizzard.com/profile/wow/character/#{self.realm.slug}/#{self.name.downcase}/statistics", :query => {
    #         'namespace' => 'profile-us',
    #         'locale' => 'en_US',
    #         'client_id' => "#{ENV['BNET_KEY']}",
    #         'client_secret' => "#{ENV['BNET_SECRET']}",
    #         'access_token' => self.user.token,
    #     })
    #     resp.deep_symbolize_keys
    # end

    # def get_character_profile
    #     BlizzardApi::Wow.character_profile.get(self.realm.slug, self.name.downcase)
    # end

    # def determine_wisdom_and_intelligence(int_value)
    #     if INT_CLASSES.include?(self.klass)
    #         self.intelligence = int_value[:effective]
    #         self.wisdom = int_value[:base]
    #     elsif WIS_CLASSES.include?(self.klass)
    #         self.wisdom = int_value[:effective]
    #         self.intelligence = int_value[:base]
    #     else
    #         self.wisdom = (int_value[:base] + 20)
    #         self.intelligence = int_value[:base]
    #     end
    # end
    
    # def add_guild(guild_info)
    #     unless guild = Guild.find_by(uid: guild_info[:id])
    #         guild = Guild.new()
    #         guild.uid = guild_info[:id]
    #         guild.name = guild_info[:name]
    #         guild.realm = get_en_US_spelling(guild_info[:realm])
    #         guild.faction = get_en_US_spelling(guild_info[:faction])
    #         guild.save!
    #     end
    #     guild
    # end
    
    # def get_en_US_spelling(field)
    #     field[:name][:en_US]
    # end

end
