class NavigationMenu < Refinery::Pages::MenuPresenter

  # Menu
  def render_menu(items)
    render_menu_items(items)
  end

  def render_menu_items(menu_items)
    if menu_items.present?
      menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
        buffer << render_menu_item(item, index)
      end
    end
  end

  # show submenu only if it is needed
  def render_submenu(menu_items = roots)
    if menu_items.present?
      menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
        buffer << render_submenu_items(menu_item_children(item)) if selected_item_or_descendant_item_selected?(item)
        buffer
      end
    end
  end

  def render_submenu_items(menu_items)
    if menu_items.present?
      menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
        buffer << render_menu_item(item, index)
      end
    end
  end

  # render a single menu itme
  def render_menu_item(menu_item, index)
    css = []
    css << "link heading"
    css << selected_css if selected_item_or_descendant_item_selected?(menu_item)

    content_tag(:span, :class => css) do
      buffer = ActiveSupport::SafeBuffer.new
      buffer << link_to(menu_item.title, context.refinery.url_for(menu_item.url))
      buffer
    end
  end
end