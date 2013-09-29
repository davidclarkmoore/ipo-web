class ButtonGroupInput <  SimpleForm::Inputs::CollectionInput
  include ApplicationHelper
  def input
    label_method, value_method = detect_collection_methods

    html = ""
    collection.each do |c|
      html += "<button class='button button-grey'>#{c}</button>"
    end

    html += @builder.collection_select(
              attribute_name, collection, value_method, label_method,
              input_options, input_html_options
            )
    html
  end
end