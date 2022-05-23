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

end