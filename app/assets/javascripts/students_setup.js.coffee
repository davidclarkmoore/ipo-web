$ ->
  $("#student_application_project_session_id").empty()
  $("#your_project_select").change (event) ->
    project_code = $(this).val()
    $.ajax
      type: "GET"
      url: "/students_setup/project_sessions/" + project_code
      success: (data) -> 
        $("#s2id_student_application_project_session_id").children().children(".select2-chosen").text("")
        $("#student_application_project_session_id").empty()
        $.each data, (index, value) ->
          $("#student_application_project_session_id").append "<option value=\"" + data[index].id + "\">" + data[index].text + "</option>"


