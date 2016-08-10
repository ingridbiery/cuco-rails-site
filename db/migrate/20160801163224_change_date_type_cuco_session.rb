class ChangeDateTypeCucoSession < ActiveRecord::Migration
  def change
    # change column is not reversible, so delete and add
    remove_column :cuco_sessions, :start_date, :string
    remove_column :cuco_sessions, :end_date, :string
    add_column :cuco_sessions, :start_date, :date
    add_column :cuco_sessions, :end_date, :date
  end
end
