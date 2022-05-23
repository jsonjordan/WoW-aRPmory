class AddMainToCharacterImages < ActiveRecord::Migration[6.1]
  def change
    add_column :character_images, :main, :string
  end
end
