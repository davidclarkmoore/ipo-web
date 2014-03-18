$ ->
  $('#spiritual_reference .tab').click (e) ->
    value =  $(@).data('box') == '#existing_spiritual_reference'
    handleTabs("new", "spiritual_reference", !value)
    handleTabs("existing", "spiritual_reference", value)
    $('#is_new_spiritual_reference').val(($(@).data('box') == "#new_spiritual_reference"))
      
  $('#academic_reference .tab').click (e) ->
    value = $(@).data('box') == '#existing_academic_reference'
    handleTabs("new", "academic_reference", !value)
    handleTabs("existing", "academic_reference", value)
    $('#is_new_academic_reference').val(($(@).data('box') == "#new_academic_reference"))

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

  $("#your_project_select").trigger("change")

handleTabs = (type, reference, display) ->
  tab = $("#tab_" + type + "_" + reference)
  content = $("#" + type + "_" + reference)

  if display
    content.show()
    tab.addClass 'active'
  else
    content.hide()
    tab.removeClass 'active'
