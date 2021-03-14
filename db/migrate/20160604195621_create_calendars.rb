class CreateCalendars < ActiveRecord::Migration[4.2]
  def change
    create_table :calendars do |t|
      t.string :googleid
      t.references :cuco_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
