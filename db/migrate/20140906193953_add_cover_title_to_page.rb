class AddCoverTitleToPage < ActiveRecord::Migration
  def change
  	add_column Refinery::Page.table_name, :cover_title, :string
  end
end
