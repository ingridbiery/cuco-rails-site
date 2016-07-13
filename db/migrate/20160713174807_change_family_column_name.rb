class ChangeFamilyColumnName < ActiveRecord::Migration
  def change
    rename_column :families, :family_name, :name
  end
end
