class AddNotificationListToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :notification_list, :boolean
  end
end
