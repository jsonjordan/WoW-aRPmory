class CreateCharacter < ActiveRecord::Migration[6.1]
  def change
    create_table :characters do |t|
      t.integer :uid, index: true
      t.string :name
      t.string :title
      t.string :klass
      t.string :spec
      t.string :race
      t.string :gender
      t.string :faction
      t.integer :level
      t.bigint :money
      t.integer :health
      t.integer :strength
      t.integer :intelligence
      t.integer :wisdom
      t.integer :constitution
      t.integer :dexterity
      t.integer :charisma
      t.integer :armor_class
      t.integer :total_deaths
      t.string :partner_type
      t.integer :partner_id
      t.string :status, index: true
      t.belongs_to :guild, foreign_key: true, index: true
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :realm, foreign_key: true, index: true

      t.timestamps
    end
  end
end
20220519133018

20220519195357