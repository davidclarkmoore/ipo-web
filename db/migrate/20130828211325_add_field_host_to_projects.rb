class AddFieldHostToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :field_host_id, :integer
    add_foreign_key :projects, :field_hosts
  end
end
