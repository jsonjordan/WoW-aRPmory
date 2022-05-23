class UpdateProtectedStatsWorker
    include Sidekiq::Worker

    #worker object that creates offical live feed for an episode
    def perform(character_uid)
        char = Character.find_by(uid: character_uid)
        protected_stats_info = get_character_protected_stats(char)

        char.money = protected_stats_info[:money]
        char.converted_money = char.convert_money
        char.total_deaths = protected_stats_info[:protected_stats][:total_number_deaths]

        char.save!

    end

    def get_character_protected_stats(char)
        resp = HTTParty.get("https://us.api.blizzard.com/profile/user/wow/protected-character/#{char.realm.uid}-#{char.uid}", :query => {
            'namespace' => 'profile-us',
            'locale' => 'en_US',
            'access_token' => char.user.token,
        })
        resp.deep_symbolize_keys
    end

end
