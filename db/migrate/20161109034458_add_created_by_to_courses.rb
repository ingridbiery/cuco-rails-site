class AddCreatedByToCourses < ActiveRecord::Migration[4.2]
  def change
    add_reference :courses, :created_by, references: :users, index: true
    add_foreign_key :courses, :users, column: :created_by_id
  end
end
