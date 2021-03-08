class CreatePeriods < ActiveRecord::Migration[4.2]
  def change
    create_table :periods do |t|
      t.string :name
      t.time :start_time
      t.time :end_time

      t.timestamps null: false
    end
  end
end
