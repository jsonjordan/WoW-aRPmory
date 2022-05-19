class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def bnet
        @user = User.from_omniauth(request.env["omniauth.auth"])

        if @user
            sign_in @user
            @user.get_characters

            set_flash_message(:notice, :success, kind: "BNET") if is_navigational_format?
            redirect_to root_path # TODO change
        else
            flash[:error] = "Could not be logged in, try again"
            redirect_to root_path
        end
    end

    def failure
        redirect_to root_path
    end

end



# redirect_uri = 'http://localhost:3000/users/auth/bnet/callback'
# ("https://us.battle.net/oauth/token?redirect_uri=#{redirect_uri}&code=code" \
#           "&grant_type=authorization_code&scope=wow.profile&client_id=#{ENV['BNET_KEY']}" \
#           "&client_secret=#{ENV['BNET_SECRET']}")


# results = HTTParty.post("https://us.battle.net/oauth/token", :query => {
#     'redirect_uri' => redirect_uri,
#     'code' => 'USiGzApXpy0Fm2lhwoAnD1X6DqxTiQX7NM',
#     'grant_type' => 'authorization_code',
#     'scope' => 'wow.profile',
#     'client_id' => "#{ENV['BNET_KEY']}",
#     'client_secret' => "#{ENV['BNET_SECRET']}",
# })

# profile_url="https://us.api.blizzard.com/oauth/userinfo",

# q = HTTParty.get("https://us.api.blizzard.com/oauth/userinfo",
#     :query => {
#         'client_id' => ENV['BNET_KEY'],
#         'scope' => 'wow.profile',
#         'redirect_uri' => redirect_uri,
#         'response_type' => 'code',
#     })

# headers = {'Authorization': 'Bearer ' + token}

# r = HTTParty.get("https://us.api.blizzard.com/profile/user/wow?namespace=profile-us&locale=en_US",
#     :headers => {
#         'Authorization' => 'Bearer ' + results['access_token'],
#     })
# HTTParty.get("https://us.battle.net/profile/user/wow?:region=us&access_token=US5J9G5R44QPD5NDROKZNEUJJRNOYDZSPO",
#     :query => {

#     })
#     https://us.battle.net/oauth/userinfo?:region=us&access_token='USiGzApXpy0Fm2lhwoAnD1X6DqxTiQX7NM'




#     /oauth/check_token?token=
#     HTTParty.get("https://us.api.blizzard.com/oauth/check_token?token=USiGzApXpy0Fm2lhwoAnD1X6DqxTiQX7NM")


#     US5J9G5R44QPD5NDROKZNEUJJRNOYDZSPO
# def protected_character_info(realm_id, character_id, token)
#     HTTParty.get("https://us.api.blizzard.com/profile/user/wow/protected-character/#{realm_id}-#{character_id}", :query => {
#         'namespace' => 'profile-us',
#         'locale' => 'en_US',
#         'access_token' => token,
#     })
# end

# https://us.api.blizzard.com/profile/user/wow/protected-character/126-103066234?
# namespace=profile-us&
# locale=en_US&
# access_token=US5b900xevzI30h1pAe9w3b882pfa5Ukw7


https://us.api.blizzard.com/data/wow/media/guild-crest/emblem/141?namespace=static-9.2.0_42277-us


HTTParty.get("https://us.api.blizzard.com/data/wow/media/guild-crest/emblem/141?namespace=static-9.2.0_42277-us", :query => {
    'client_id' => "#{ENV['BNET_KEY']}",
    'client_secret' => "#{ENV['BNET_SECRET']}",
    'namespace' => 'profile-us',
        'locale' => 'en_US',
    })