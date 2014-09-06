class AddColumnImageToPagePart < ActiveRecord::Migration
  def change
  	add_column Refinery::PagePart.table_name, :column_image_id, :integer
  end
end
