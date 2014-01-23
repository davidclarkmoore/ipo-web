Refinery::Page.class_eval do
  scope :in_main_menu, -> { where(show_in_menu: true, parent_id: nil) }
  scope :pages_related, lambda { |parent_page| where(parent_id: parent_page, show_in_menu: true) }


  def has_nested_pages?
    !Refinery::Page.pages_related(self.id).empty?
  end

end