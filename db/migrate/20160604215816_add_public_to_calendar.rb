class AddPublicToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :public, :boolean
  end
end
