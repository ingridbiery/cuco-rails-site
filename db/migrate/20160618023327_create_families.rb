class CreateFamilies < ActiveRecord::Migration[4.2]
  def change
    create_table :families do |t|
      t.string :family_name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip

      t.timestamps null: false
    end
  end
end
