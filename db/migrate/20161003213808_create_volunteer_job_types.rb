class CreateVolunteerJobTypes < ActiveRecord::Migration
  def change
    create_table :volunteer_job_types do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
