class AddGoogleidToEvent < ActiveRecord::Migration
  def change
    add_column :events, :googleid, :string
    rename_column :events, :start, :start_dt
    rename_column :events, :end, :end_dt
  end
end
