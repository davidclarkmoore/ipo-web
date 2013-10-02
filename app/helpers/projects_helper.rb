module ProjectsHelper

  def wizard_step(label, index, current_step)
    content_tag(:li) do
      raw(
        label +
        if index == current_step
          content_tag(:span, "", class: "circle")
        else
          content_tag(:span, "", class: "small-circle")
        end
      )
    end
  end
end