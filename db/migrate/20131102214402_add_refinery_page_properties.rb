class AddRefineryPageProperties < ActiveRecord::Migration
  def change
    add_column :refinery_page_parts, :color, :string
    add_column :refinery_page_parts, :display_type, :string
  end
end
