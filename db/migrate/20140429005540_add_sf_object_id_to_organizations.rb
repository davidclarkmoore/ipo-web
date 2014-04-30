class AddSfObjectIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :sf_object_id, :string
  end
end
