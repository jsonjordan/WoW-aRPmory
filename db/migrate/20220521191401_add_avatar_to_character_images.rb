class AddAvatarToCharacterImages < ActiveRecord::Migration[6.1]
  def change
    add_column :character_images, :avatar, :string
  end
end
