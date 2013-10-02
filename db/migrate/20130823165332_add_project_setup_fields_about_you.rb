class AddProjectSetupFieldsAboutYou < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :organization_type, null: false
      t.string :website
    end
    create_table :field_hosts do |t|
      t.string :sf_object_id
      t.string :first_name, null: false
      t.string :middle_initial, limit: 1
      t.string :last_name, null: false
      t.string :salutation
      t.string :role_title
      t.string :email, null: false
      t.string :preferred_phone
      t.string :phone_type
      t.integer :organization_id
      t.foreign_key :organizations
      t.hstore :properties

      t.timestamps
    end
    add_column :projects, :organization_id, :integer
    add_foreign_key :projects, :organizations
  end
end
