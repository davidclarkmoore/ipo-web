module ProjectsHelper

  def wizard_step(label, index, url, current_step)
    content_tag(:li) do
      raw(
        if index == current_step
          link_to(url) do
            raw(label + content_tag(:span, "", class: "circle"))
          end
        elsif index < current_step
          link_to(url) do
            raw(label + content_tag(:span, "", class: "small-circle"))
          end
        else
          label + content_tag(:span, "", class: "small-circle")
        end
      )
    end
  end

  def fields_of_study
    current_fields_of_study.invert
  end

  def student_passions
    current_student_passions.invert
  end
end