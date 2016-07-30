class RefactorCucoSession < ActiveRecord::Migration
  def change
    # add dates and calendar ids to cuco_sessions
    add_column :cuco_sessions, :start_date, :string
    add_column :cuco_sessions, :end_date, :string
    
    # get rid of calendars table
    drop_table :calendars do |t|
      t.string   :google_id
      t.integer  :cuco_session_id
      t.boolean  :members_only
    end

    # create an event types table (for things like fees_due, schedule_posted, etc.)
    create_table :event_types do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :dates do |t|
      t.string :public_calendar_gid
      t.string :member_calendar_gid
      t.references :cuco_session, index: true, foreign_key: true
    end
  

    # update events table
    rename_column :events, :title, :name
    rename_column :events, :googleid, :google_id
    add_column :events, :members_only, :boolean
    add_reference :events, :dates, index: true, foreign_key: true
    add_reference :events, :event_type, index: true, foreign_key: true
    remove_reference :events, :calendar, index: true, foreign_key: true
    remove_column :events, :members_only, :boolean
  end
end
