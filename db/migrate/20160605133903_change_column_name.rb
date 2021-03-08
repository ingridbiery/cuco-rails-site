class ChangeColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :calendars, :public, :members_only
  end
end
