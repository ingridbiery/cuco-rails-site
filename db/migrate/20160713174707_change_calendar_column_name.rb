class ChangeCalendarColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :calendars, :googleid, :google_id
  end
end
