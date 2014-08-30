class AddFooterCategoryToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :footer_category, :string
  end
end
