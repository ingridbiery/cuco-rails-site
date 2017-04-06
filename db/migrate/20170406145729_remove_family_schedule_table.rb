class RemoveFamilyScheduleTable < ActiveRecord::Migration
  def change
    drop_table :family_schedules
  end
end
