Refinery::Page.class_eval do
  
  extend Enumerize
  enumerize :footer_category, in: %w[explore about resources]
  attr_accessible :footer_category, :cover_title, :cover_image, :cover_image_id

  scope :footer_category, lambda { |category| where(footer_category: category) }
  
  scope :in_main_menu, -> { where(show_in_menu: true, parent_id: nil) }
  scope :pages_related, lambda { |parent_page| where(parent_id: parent_page, show_in_menu: true) }

  belongs_to :cover_image, class_name: Refinery::Image

  # =================
  # TEMPORARY KLUDGE:
  # =================
  # In develompent mode, due to how refinery and Rails' autoloading works, all the refinery
  # decorator files are loaded and then reloaded on launch. This causes a problem with searchkick
  # complaining about already being loaded. This hack prevents searchkick from being loaded more than once
  # in development mode. Need to find a better solution :-(

  if Rails.env.development?
    searchkick autocomplete: ['title'] if not respond_to?(:searchkick_index)
  else
    searchkick autocomplete: ['title']
  end

  def search_data
    as_json methods: [:title, :bodies]
  end

  def bodies
    self.parts.map{|part| ActionController::Base.helpers.strip_tags(part.body) }
  end

  def has_nested_pages?
    !Refinery::Page.pages_related(self.id).empty?
  end

end
