class CreateMemberships < ActiveRecord::Migration[4.2]
  def change
    create_table :memberships do |t|
      t.references :family, index: true, foreign_key: true
      t.references :cuco_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
