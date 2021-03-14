class CreateCucoSessions < ActiveRecord::Migration[4.2]
  def change
    create_table :cuco_sessions do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
