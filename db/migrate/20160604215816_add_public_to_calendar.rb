class AddPublicToCalendar < ActiveRecord::Migration[4.2]
  def change
    add_column :calendars, :public, :boolean
  end
end
