class AddParamsToMemberships < ActiveRecord::Migration[4.2]
  def change
    add_column :memberships, :notification_params, :text
    add_column :memberships, :status, :string
    add_column :memberships, :transaction_id, :string
    add_column :memberships, :purchased_at, :datetime
  end
end
