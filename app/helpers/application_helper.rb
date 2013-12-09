module ApplicationHelper

  def image_sprite(image, options = {})
    sprites = {
      pencil: {w: 27, h: 27, x: 0, y: 0},
      arrow_right: {w: 27, h: 23, x: 145, y: 72},
      search: {w: 32, h: 32, x: 0, y: 72},
      thumbs_up: {w: 24, h: 29, x: 79, y: 72}
    }
    raw %(<span class="sprite #{image}"
      title="#{options[:title]}"
      style="background:
               url(#{path_to_image('/assets/spritesheet.png')}) no-repeat -#{sprites[image][:x]}px -#{sprites[image][:y]}px;
               width: #{sprites[image][:w]}px;
               height: #{sprites[image][:h]}px;
               #{options[:style]}">
        #{options[:title]}
      </span>)
  end

  def sort_button name, sort
    current_sort = params[:q].try(:[], "s") || nil
    button_link_to name, url_for(q: {s: sort}), :grey, class: (current_sort == sort) ? 'active' : ''
  end

  def view_active? type
    params[:view] == type ? 'active' : ''
  end

  def large_button label, color, options={}
    options[:class] ||= ""
    options[:class] += " large"
    button(label, color, options)
  end

  def button label, color, options={}
    options[:class] ||= ""
    options[:class] += " button button-#{color.to_s}"
    content_tag(:button, options) do
      if block_given?
        yield
      else
        label
      end
    end
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