class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :calendars, :public, :members_only
  end
end
