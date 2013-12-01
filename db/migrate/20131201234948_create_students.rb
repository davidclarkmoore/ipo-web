class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :birthday
      t.string :gender
      t.string :marital_status
      t.string :organization
      t.text :experiences
      t.text :heard_about_ipo
      t.boolean :applied_ipo_before
      t.text :passions
      t.string :overall_education
      t.string :graduation_year
      t.text :spoken_languages
      t.text :fields_of_study
      t.text :description
      t.integer :academic_reference_id
      t.integer :spiritual_reference_id

      t.string :street_address
      t.string :city
      t.string :postal_code
      t.string :country
      t.string :preferred_phone
      t.string :phone_type

      t.string :wizard_status
      t.hstore :properties

      # Can be a model StudentApplication to support multiple project application by Student
      t.integer :project_id
      t.integer :project_session_id

      t.timestamps
    end
  end
end
