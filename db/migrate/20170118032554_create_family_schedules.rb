class CreateFamilySchedules < ActiveRecord::Migration[4.2]
  def change
    create_table :family_schedules do |t|
      t.references :cuco_session, index: true, foreign_key: true
      t.references :family, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
