class InitializeCharacterImageWorker
    include Sidekiq::Worker

    #worker object that creates offical live feed for an episode
    def perform(character_uid)
        char = Character.find_by(uid: character_uid)
        character_image_info = get_character_image(char)

        character_image_info[:assets].each do |image|
            ci = CharacterImage.new
            ci.catagory = image[:key]
            ci.status = 'active'
            ci.character = char
            if ci.save
                set_image_url(image, ci)
            end
        end

    end

    def get_character_image(char)
        resp = HTTParty.get("https://us.api.blizzard.com/profile/wow/character/#{char.realm.slug}/#{char.name.downcase}/character-media", :query => {
            'namespace' => 'profile-us',
            'locale' => 'en_US',
            'client_id' => "#{ENV['BNET_KEY']}",
            'client_secret' => "#{ENV['BNET_SECRET']}",
            'access_token' => char.user.token,
        })
        resp.deep_symbolize_keys
    end

    def set_image_url(image, character_image)
        if image[:key] == 'main-raw'
            UpdateMainRawImageWorker.perform_async(character_image.id, image[:value])
        else 
            character_image.url = image[:value]
            character_image.save!
        end
    end
end