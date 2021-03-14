class AddPrimaryAdultToFamilies < ActiveRecord::Migration[4.2]
  def change
    add_column :families, :primary_adult, :integer
  end
end
