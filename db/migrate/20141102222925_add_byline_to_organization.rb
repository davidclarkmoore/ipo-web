class AddBylineToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :byline, :text
  end
end
