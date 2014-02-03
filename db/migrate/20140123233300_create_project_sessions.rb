class CreateProjectSessions < ActiveRecord::Migration
  def change
    create_table :project_sessions do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.integer :project_id
      t.date :application_deadline
      t.string :status
      t.timestamps
    end
  end
end
