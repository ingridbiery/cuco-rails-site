class AddEmergencyContactToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :ec_first_name, :string
    add_column :families, :ec_last_name, :string
    add_column :families, :ec_phone, :string
    add_column :families, :ec_text, :boolean
    add_column :families, :ec_relationship, :string
  end
end
