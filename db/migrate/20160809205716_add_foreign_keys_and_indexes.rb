class AddForeignKeysAndIndexes < ActiveRecord::Migration[4.2]
  def change
    # make sure all of our references to other tables have foreign keys
    add_foreign_key :courses, :cuco_sessions
    add_foreign_key :families, :people, column: :primary_adult_id
    add_foreign_key :people, :pronouns
    add_foreign_key :roles_users, :roles
    add_foreign_key :roles_users, :users
    
    # make sure all foreign keys are indexed
    add_index :courses, :cuco_session_id
    add_index :families, :primary_adult_id
    add_index :people, :pronoun_id
    add_index :roles_users, :role_id
    add_index :roles_users, :user_id
  end
end
