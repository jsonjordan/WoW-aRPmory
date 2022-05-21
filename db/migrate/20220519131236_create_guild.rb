class CreateGuild < ActiveRecord::Migration[6.1]
  def change
    create_table :guilds do |t|
      t.integer :uid, index: true
      t.string :name, index: true
      t.string :realm
      t.string :faction
      t.string :crest_url

      t.timestamps
    end
  end
end
