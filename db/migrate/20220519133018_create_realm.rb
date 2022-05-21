class CreateRealm < ActiveRecord::Migration[6.1]
  def change
    create_table :realms do |t|
      t.string :name
      t.integer :uid
      t.string :slug

      t.timestamps
    end
  end
end
