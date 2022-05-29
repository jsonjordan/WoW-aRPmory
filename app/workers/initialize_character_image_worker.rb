class InitializeCharacterImageWorker
    include Sidekiq::Worker

    #worker object that creates offical live feed for an episode
    def perform(character_uid)
        char = Character.find_by(uid: character_uid)
        character_image_info = get_character_image(char)

        character_image_info[:assets].each do |image|
            ci = CharacterImage.new
            ci.title = 'My first image'
            ci.catagory = image[:key]
            ci.status = 'active'
            ci.character = char
            if ci.save
                set_image_urls(image, char, ci)
                char.save!
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

    def set_image_urls(image, character, character_image)
        if image[:key] == 'main-raw'
            character.remote_main_raw_url = image[:value]
            UpdateMainRawImageWorker.perform_async(character_image.id, image[:value])
        else
            if image[:key] == 'inset'
                character.remote_inset_url = image[:value]
            elsif image[:key] == 'avatar'
                character.remote_avatar_url = image[:value]
            elsif image[:key] == 'main'
                character.remote_main_url = image[:value]
            end
            character_image.url = image[:value]
            character_image.save!
        end
    end
end