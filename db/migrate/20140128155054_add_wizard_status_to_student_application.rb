class AddWizardStatusToStudentApplication < ActiveRecord::Migration
  def change
    add_column :student_applications, :wizard_status, :string
    add_column :student_applications, :agree_terms, :boolean
    
    remove_column :students, :wizard_status
  end
end
