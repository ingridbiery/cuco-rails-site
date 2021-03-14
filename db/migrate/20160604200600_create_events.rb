class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.references :calendar, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
