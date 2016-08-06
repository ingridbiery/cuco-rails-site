class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :family, index: true, foreign_key: true
      t.references :cuco_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
