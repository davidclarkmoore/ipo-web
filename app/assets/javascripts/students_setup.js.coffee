$ ->
  $("#your_project_select").change (event) ->
    project_code = $(this).val()
    $.ajax
      type: "GET"
      url: "/students_setup/project_sessions/" + project_code
      success: (data) -> 
        $("#student_student_applications_attributes_0_project_session_id").empty()
        $.each data, (index, value) ->
          $("#student_student_applications_attributes_0_project_session_id").append "<option value=\"" + data[index].id + "\">" + data[index].text + "</option>"

