class AddGoogleAuthToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :token, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
