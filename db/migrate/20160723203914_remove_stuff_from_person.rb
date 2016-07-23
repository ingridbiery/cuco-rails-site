class RemoveStuffFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :email, :string
    remove_column :people, :phone, :string
  end
end
