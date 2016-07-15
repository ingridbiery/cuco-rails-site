class RemovePrimaryAdultFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :primary_adult, :boolean
  end
end
