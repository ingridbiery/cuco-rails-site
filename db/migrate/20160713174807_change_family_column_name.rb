class ChangeFamilyColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :families, :family_name, :name
  end
end
