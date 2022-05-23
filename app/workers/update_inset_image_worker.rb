class UpdateInsetImageWorker
    include Sidekiq::Worker

    #worker object that creates offical live feed for an episode
    def perform(character_image_id, url)

        ci = CharacterImage.find(character_image_id)

        ci.remote_inset_url = url
        if ci.save
            ci.url = ci.inset.url
            ci.save!
        end

    end

end
