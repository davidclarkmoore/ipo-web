class AddSfObjectIdToStudentApplication < ActiveRecord::Migration
  def change
    add_column :student_applications, :sf_object_id, :string
    add_column :references, :sf_object_id, :string
  end
end
