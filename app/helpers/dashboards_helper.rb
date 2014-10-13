module DashboardsHelper

  CLASSES = { 
        Project::DENIED => "denied",
        Project::APPROVED => "approved",
        Project::INCOMPLETE => "incomplete",
        Project::COMPLETE => "complete",
        Project::IN_REVIEW => "in_review"
  }

  def project_status_tag(project_session, html_options = {})
    options = { class: CLASSES[project_session.status] }.merge(html_options)
    content_tag(:span, options) do
      project_session.status_text
    end
  end
end
