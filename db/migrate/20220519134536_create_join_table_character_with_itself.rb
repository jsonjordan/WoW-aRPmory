class CreateJoinTableCharacterWithItself < ActiveRecord::Migration[6.1]
  def change
    create_table :character_guild_connections do |t|
      t.integer :main_character_id, :null => false
      t.integer :guildie_id, :null => false
    end
  end
end