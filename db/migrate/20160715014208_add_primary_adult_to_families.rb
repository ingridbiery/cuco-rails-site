class AddPrimaryAdultToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :primary_adult, :integer
  end
end
