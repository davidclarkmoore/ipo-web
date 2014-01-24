class CreateProjectSessions < ActiveRecord::Migration
  def change
    create_table :project_sessions do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.integer :project_id
      t.timestamps
    end
  end
end
