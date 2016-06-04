class CreateCucoSessions < ActiveRecord::Migration
  def change
    create_table :cuco_sessions do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
