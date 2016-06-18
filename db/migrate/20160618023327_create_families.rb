class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :family_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps null: false
    end
  end
end
