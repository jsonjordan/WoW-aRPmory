class AddMainRawToCharacterImages < ActiveRecord::Migration[6.1]
  def change
    add_column :character_images, :main_raw, :string
  end
end
