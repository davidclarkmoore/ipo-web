class AddColumnReservedHisSpotToStudentApplication < ActiveRecord::Migration
  def change
    add_column :student_applications, :reserved_his_spot, :boolean
  end
end
