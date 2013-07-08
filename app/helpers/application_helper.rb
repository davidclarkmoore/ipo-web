module ApplicationHelper

  def sort_button name, sort
    current_sort = params[:q].try(:[], "s") || nil
    button_link_to name, url_for(q: {s: sort}), :grey, class: (current_sort == sort) ? 'active' : ''
  end

  def view_active? type
    params[:view] == type ? 'active' : ''
  end

  def button label, color, options={}
    content_tag(:button, label, class: "button button-#{color.to_s}")
  end

  def button_link_to label, href, color, options={}
    # TODO: There must be a better way to initialize defaults?
    options ||= {}
    options[:class] ||= ""

    options[:class] += " button button-#{color.to_s}"
    link_to label, href, options
  end


  def dropdown default_option, &block
    content_tag :div, class: 'button-dropdown' do
      raw(
        content_tag(:span, default_option, class: 'button') +
        content_tag(:a, 'More', class: 'button toggle') +
        content_tag(:ul, class: 'dropdown') do
          yield
        end
      )
    end
  end

  def dropdown_btn label
    content_tag :li do
      content_tag(:span, label, class: 'dropdown-link')
    end
  end

end