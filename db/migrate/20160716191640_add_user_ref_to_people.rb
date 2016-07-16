class AddUserRefToPeople < ActiveRecord::Migration
  def change
    add_reference :people, :user, index: true
  end
end
