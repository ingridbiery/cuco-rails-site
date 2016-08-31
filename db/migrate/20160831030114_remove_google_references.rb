class RemoveGoogleReferences < ActiveRecord::Migration
  def change
    remove_column :events, :google_id, :string
    remove_column :dates, :public_calendar_gid, :string
    remove_column :dates, :member_calendar_gid, :string
  end
end
