class AddContactDetailsToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :email, :string
    add_column :people, :phone, :string
    add_column :people, :facebook, :string
    add_column :people, :twitter, :string
    add_column :people, :skype, :string
  end
end
