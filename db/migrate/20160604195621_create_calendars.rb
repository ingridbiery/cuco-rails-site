class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :googleid
      t.references :cuco_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
