class RemoveUsersPersonForeignKey < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :users, column: :person_id
  end
end
