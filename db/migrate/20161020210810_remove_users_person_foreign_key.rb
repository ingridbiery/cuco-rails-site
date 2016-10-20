class RemoveUsersPersonForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key :users, column: :person_id
  end
end
