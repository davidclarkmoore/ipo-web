class CreatePersonReferences < ActiveRecord::Migration
  def change
    create_table :person_references do |t|
      t.string :reference_type #spiritual, academic, other
      t.belongs_to :reference
      t.references :referencer, polymorphic: true
      t.timestamps
    end
=begin
      Student.all.each do |student|
      academic_ref_id = student.academic_reference_id
      student_ref_id = student.spiritual_reference_id
      person_reference = PersonReferences.new
      student.build_person_reference
    end
    change_table :students do |t|
      t.remove_column academic_reference_id
      t.remove_column spiritual_reference_id
    end
=end
  end
end
