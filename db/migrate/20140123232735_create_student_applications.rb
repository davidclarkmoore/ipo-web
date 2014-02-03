class CreateStudentApplications < ActiveRecord::Migration
  def change
    create_table :student_applications do |t|
      t.integer :project_session_id
      t.integer :student_id
      t.string  :status
      t.timestamps
    end
  end
end
