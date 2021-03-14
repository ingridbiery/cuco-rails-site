class RemoveForeignKeyPrimaryAdult < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :families, column: :primary_adult_id
  end
end
