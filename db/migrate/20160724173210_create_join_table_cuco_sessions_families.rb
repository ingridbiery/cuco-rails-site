class CreateJoinTableCucoSessionsFamilies < ActiveRecord::Migration
  def change
    create_join_table :cuco_sessions, :families do |t|
      # t.index [:cuco_session_id, :family_id]
      # t.index [:family_id, :cuco_session_id]
    end
  end
end
