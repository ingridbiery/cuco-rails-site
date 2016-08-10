class RemoveForeignKeyPrimaryAdult < ActiveRecord::Migration
  def change
    remove_foreign_key :families, column: :primary_adult_id
  end
end
