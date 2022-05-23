class AddInsetToCharacterImages < ActiveRecord::Migration[6.1]
  def change
    add_column :character_images, :inset, :string
  end
end
