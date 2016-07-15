class ChangeCalendarColumnName < ActiveRecord::Migration
  def change
    rename_column :calendars, :googleid, :google_id
  end
end
