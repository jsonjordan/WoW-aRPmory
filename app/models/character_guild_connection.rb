# class CharacterGuildConnection < ApplicationRecord
#     validates_uniqueness_of :main_character, scope: :guildie

#     belongs_to :main_character, class_name: :Character
#     belongs_to :guildie, class_name: :Character

#     def self.create(character_1_id, character_2_id)
#         cg = CharacterGuildConnection.new(main_character_id: character_1_id, guildie_id: character_2_id)
#         cg.save!
#         cg2 = CharacterGuildConnection.new(main_character_id: character_2_id, guildie_id: character_1_id)
#         cg2.save!
#     end

# end
