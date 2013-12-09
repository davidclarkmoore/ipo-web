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
    Project.related_fields_of_study.values
  end

  def student_passions
    Project.related_student_passions.values
  end
end