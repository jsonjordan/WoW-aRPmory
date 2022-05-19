class AddBnetInfoToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string, null: false
    add_column :users, :battletag, :string, null: false
    add_column :users, :bnet_hash, :json
    add_column :users, :token, :string
    add_column :users, :token_expiry, :datetime
    add_index :users, :battletag, unique: true
    add_index :users, :uid, unique: true
  end
end
