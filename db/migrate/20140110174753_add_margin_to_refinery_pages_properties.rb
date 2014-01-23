class AddMarginToRefineryPagesProperties < ActiveRecord::Migration
  def change
    add_column :refinery_page_parts, :margin, :string
  end
end
