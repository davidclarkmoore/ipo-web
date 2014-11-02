class AddTimestampsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :created_at, :datetime
    add_column :organizations, :updated_at, :datetime
  end
end
