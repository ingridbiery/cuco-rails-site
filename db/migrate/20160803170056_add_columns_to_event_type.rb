class AddColumnsToEventType < ActiveRecord::Migration[4.2]
  def change
    add_column :event_types, :display_name, :string
    add_column :event_types, :start_date_offset, :integer
    add_column :event_types, :start_time, :time
    add_column :event_types, :end_date_offset, :integer
    add_column :event_types, :end_time, :time
    add_column :event_types, :members_only, :boolean
    add_column :event_types, :registration, :boolean
  end
end
