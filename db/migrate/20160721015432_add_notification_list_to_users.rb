class AddNotificationListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_list, :boolean
  end
end
