class AddStatusAndPayRegistrationToStudentApplication < ActiveRecord::Migration
  def change
    add_column :student_applications, :sf_status, :string
    add_column :student_applications, :pay_registration_fee, :boolean
  end
end
