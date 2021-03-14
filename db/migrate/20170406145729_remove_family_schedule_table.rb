class RemoveFamilyScheduleTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :family_schedules
  end
end
