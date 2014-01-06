Refinery::Page.class_eval do
  scope :in_main_menu, -> { where(show_in_menu: true, parent_id: nil) }
end