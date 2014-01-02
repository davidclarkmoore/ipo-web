class SetupArrayFieldsInProject < ActiveRecord::Migration
  def change
    add_column :projects, :related_fields_of_study, :string, array: true
    add_column :projects, :related_student_passions, :string, array: true
  end
end
