class AddCeramicsNumberToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :ceramics_number, :integer
  end
end
