class SaveCurrentImagesWorker
    include Sidekiq::Worker

    def perform(character_uid, types_array)
        char = Character.find_by(uid: character_uid)

        types_array.each do |type|
            ci = CharacterImage.new
            ci.title = type['title']
            ci.catagory = type['catagory']
            ci.status = 'inactive'
            ci.character = char
            if ci.save
                set_image_url(type['catagory'], char, ci.id)
            end
        end

    end

    def set_image_url(type, char, character_image_id)
        if type == 'inset'
            url = char.remote_inset_url
            UpdateInsetImageWorker.perform_async(character_image_id, url)
        elsif type == 'avatar'
            url = char.remote_avatar_url
            UpdateAvatarImageWorker.perform_async(character_image_id, url)
        elsif type == 'main'
            url = char.remote_main_url
            UpdateMainImageWorker.perform_async(character_image_id, url)
        elsif type == 'main-raw'
            url = char.remote_main_raw_url
            UpdateMainRawImageWorker.perform_async(character_image_id, url)
        end
    end

end