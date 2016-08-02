class ChangeDateTypeCucoSession < ActiveRecord::Migration
  def change
    change_column :cuco_sessions, :start_date, :date
    change_column :cuco_sessions, :end_date, :date
  end
end
