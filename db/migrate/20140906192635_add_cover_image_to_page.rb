class AddCoverImageToPage < ActiveRecord::Migration
  def change
  	add_column Refinery::Page.table_name, :cover_image_id, :integer
  end
end
