class RemovePrimaryAdultFromPeople < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :primary_adult, :boolean
  end
end
