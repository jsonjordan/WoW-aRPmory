class CharacterImage < ApplicationRecord

    belongs_to :character

    validates :title, uniqueness: { scope: [:catagory, :character_id] }
    #for carrierwave
    mount_uploader :inset, InsetUploader
    mount_uploader :avatar, AvatarUploader
    mount_uploader :main, MainUploader
    mount_uploader :main_raw, MainRawUploader

    def cropped_image(params)
        image = MiniMagick::Image.open(self.main_raw.url)
        crop_params = "#{params[:w]}x#{params[:h]}+#{params[:x]}+#{params[:y]}"
        image.crop(crop_params)
    
        image
    end
    
end