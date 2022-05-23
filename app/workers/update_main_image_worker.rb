class UpdateMainImageWorker
    include Sidekiq::Worker

    #worker object that creates offical live feed for an episode
    def perform(character_image_id, url)

        ci = CharacterImage.find(character_image_id)

        ci.remote_main_url = url
        if ci.save
            ci.url = ci.main.url
            ci.save!
        end

    end

end
