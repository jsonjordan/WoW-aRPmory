class CreateCharacterImages < ActiveRecord::Migration[6.1]
  def change
    create_table :character_images do |t|
      t.string :catagory, index: true
      t.string :title
      t.string :url
      t.string :status, index: true
      t.belongs_to :character, foreign_key: true, index: true

      t.timestamps
    end
  end
end
