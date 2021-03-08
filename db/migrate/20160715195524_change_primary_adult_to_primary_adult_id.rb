class ChangePrimaryAdultToPrimaryAdultId < ActiveRecord::Migration[4.2]
  def change
    rename_column :families, :primary_adult, :primary_adult_id
  end
end
