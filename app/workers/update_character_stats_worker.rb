class UpdateCharacterStatsWorker
    include Sidekiq::Worker
  
    INT_CLASSES = ['Warlock', 'Mage']
    WIS_CLASSES = ['Druid', 'Paladin', 'Priest', 'Shaman']

    #worker object that creates offical live feed for an episode
    def perform(character_uid)
        char = Character.find_by(uid: character_uid)
        character_stats_info = get_character_stats(char)

        char.armor_class = character_stats_info[:armor][:effective]
        char.health = character_stats_info[:health]
        char.strength = character_stats_info[:strength][:effective]
        char.constitution = character_stats_info[:stamina][:effective]
        char.dexterity = character_stats_info[:agility][:effective]
        char.charisma = character_stats_info[:mastery][:rating]
        determine_wisdom_and_intelligence(char, character_stats_info[:intellect])

        char.save!

    end
  
    def get_character_stats(char)
        resp = HTTParty.get("https://us.api.blizzard.com/profile/wow/character/#{char.realm.slug}/#{char.name.downcase}/statistics", :query => {
            'namespace' => 'profile-us',
            'locale' => 'en_US',
            'client_id' => "#{ENV['BNET_KEY']}",
            'client_secret' => "#{ENV['BNET_SECRET']}",
            'access_token' => char.user.token,
        })
        resp.deep_symbolize_keys
    end

    def determine_wisdom_and_intelligence(character, intellect_value)
        if INT_CLASSES.include?(character.klass)
            character.intelligence = intellect_value[:effective]
            character.wisdom = intellect_value[:base]
        elsif WIS_CLASSES.include?(character.klass)
            character.wisdom = intellect_value[:effective]
            character.intelligence = intellect_value[:base]
        else
            character.wisdom = (intellect_value[:base] + 20)
            character.intelligence = intellect_value[:base]
        end
    end
  
  end