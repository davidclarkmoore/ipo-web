class AddSfObjectIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :sf_object_id, :string
  end
end
