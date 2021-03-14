class RemoveSocialMediaFieldsFromPeople < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :facebook, :string
    remove_column :people, :twitter, :string
    remove_column :people, :skype, :string
  end
end
