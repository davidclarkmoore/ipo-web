module DashboardsHelper

  def project_status_tag(project_session, html_options = {})
    options = { class: project_session.status }.merge(html_options)
    content_tag(:span, options) do
      project_session.status_text
    end
  end

end
