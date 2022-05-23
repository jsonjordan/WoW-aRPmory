class UpdateCharacterProfileWorker
  include Sidekiq::Worker

  #worker object that creates offical live feed for an episode
  def perform(character_uid)
    char = Character.find_by(uid: character_uid)
    character_profile_info = get_character_profile(char)

    char.spec = get_en_US_spelling(character_profile_info[:active_spec])
    char.title = get_en_US_spelling(character_profile_info[:active_title])
    char.race = get_en_US_spelling(character_profile_info[:race])
    char.gender = get_en_US_spelling(character_profile_info[:gender])
    char.faction = get_en_US_spelling(character_profile_info[:faction])
    char.status = 'active'

    if character_profile_info[:guild]
      char.guild = add_guild(character_profile_info[:guild])
    else
      char.guild = Guild.find_by(uid: 0)
    end

    char.save!
  end

  def get_character_profile(char)
    BlizzardApi::Wow.character_profile.get(char.realm.slug, char.name.downcase)
  end

  def add_guild(guild_info)
    Guild.with_advisory_lock('new_guild') do
      unless guild = Guild.find_by(uid: guild_info[:id])
        guild = Guild.new()
        guild.uid = guild_info[:id]
        guild.name = guild_info[:name]
        guild.realm = get_en_US_spelling(guild_info[:realm])
        guild.faction = get_en_US_spelling(guild_info[:faction])
        guild.save!
      end
      guild
    end
  end

  def get_en_US_spelling(field)
    field[:name][:en_US]
  end

end
