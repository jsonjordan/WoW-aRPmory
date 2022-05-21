class CharacterController < ApplicationController

    def select
        @character = Character.new
        @inactive_characters = current_user.characters
            .where(status: 'disabled')
            .where("level > ?", 10) 
            .includes(:realm)
            .order("realms.name")
            .order(level: :desc)
            .order(:name)
        @active_characters = current_user.characters
            .where(status: 'active')
            .where("level > ?", 10) 
            .includes(:realm)
            .order("realms.name")
            .order(level: :desc)
            .order(:name)

    end

    def update
        char_uids = params[:character_uids]
        char_uids.each do |cuid|
            char = Character.find_by(uid: cuid.to_i)
            char.deep_update
        end
    end

end