class ButtonGroupInput <  SimpleForm::Inputs::CollectionInput
  include ApplicationHelper
  def input
    label_method, value_method = detect_collection_methods

    html = ""
    collection.each do |c|
      if c.instance_of?(Array)
        html += "<button class='button button-grey' data-value='#{c[1]}'>#{c[0]}</button>"
      else
        html += "<button class='button button-grey'>#{c}</button>"
      end
    end

    input_html_options[:class].push "no-select2"
    input_html_options[:class].push "offscreen"

    html += @builder.collection_select_with_client_side_validations(
              attribute_name, collection, value_method, label_method,
              input_options, input_html_options
            )
    html
  end
end