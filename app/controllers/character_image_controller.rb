class CharacterImageController < ApplicationController

    def select_body_image
        @images = Character.find_by(uid: params[:character_uid]).character_images.where(catagory: 'main-raw')
    end

end