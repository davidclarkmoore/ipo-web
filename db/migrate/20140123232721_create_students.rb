class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :birthday
      t.string :gender
      t.string :street_address
      t.string :city
      t.string :postal_code
      t.string :country
      t.string :preferred_phone
      t.string :phone_type
      t.hstore :properties
      t.string :marital_status
      t.string :organization
      t.boolean :applied_ipo_before
      t.text :description
      t.string :wizard_status
      t.integer :academic_reference_id
      t.integer :spiritual_reference_id    
      
      t.timestamps
    end
  end
end
