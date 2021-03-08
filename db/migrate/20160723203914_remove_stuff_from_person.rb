class RemoveStuffFromPerson < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :email, :string
    remove_column :people, :phone, :string
  end
end
