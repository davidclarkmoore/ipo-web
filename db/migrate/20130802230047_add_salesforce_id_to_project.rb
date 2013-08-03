class AddSalesforceIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :sf_object_id, :string
  end
end
