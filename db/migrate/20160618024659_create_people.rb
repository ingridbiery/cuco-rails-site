class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.boolean :primary_adult
      t.references :family, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :people, [:family_id, :created_at]
  end
end
