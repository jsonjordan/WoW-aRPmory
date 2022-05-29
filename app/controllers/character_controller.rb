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
            char.initialize_with_deep_update
        end
        if user = User.find { |u| u.no_hash_battletag == params[:user_battletag] }
            flash[:notice] = "Characters being added, this may take a moment and you may need to refresh."
            redirect_to user_character_index_path(user.no_hash_battletag)
        else
            render :select
        end

    end

    def user_index
        @user = User.find { |u| u.no_hash_battletag == params[:user_battletag] }
        @user_characters = current_user.characters
            .where(status: 'active')
            .where("level > ?", 10) 
            .includes(:realm)
            .order("realms.name")
            .order(level: :desc)
            .order(:name)
    end

    def show
        @character = Character.find_by(uid: params[:character_uid])
    end

    def todays_images
        @character = Character.find_by(uid: params[:character_uid])
    end

    def save_current_images
        char_uid = params[:character_uid]
        types_array = []
        params[:image_types].each do |type|
            type_hash = Hash.new
            type_hash[:catagory] = type
            type_hash[:title] = params[:title]
            types_array.push(type_hash)
        end

        char = Character.find_by(uid: char_uid.to_i)
        char.save_current_images(types_array)

        flash[:notice] = "Images being added, this may take a moment and you may need to refresh."
        redirect_to user_character_index_path(char.user.no_hash_battletag)
    end

end
