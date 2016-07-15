class ChangePrimaryAdultToPrimaryAdultId < ActiveRecord::Migration
  def change
    rename_column :families, :primary_adult, :primary_adult_id
  end
end
