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

  $("#your_project_select").change (event) ->
    project_code = $(this).val()
    $.ajax
      type: "GET"
      url: "/students_setup/project_sessions/" + project_code
      success: (data) -> 
        $("#s2id_student_application_project_session_id").children().children(".select2-chosen").text("")
        $("#student_application_project_session_id").empty()
        selected = null
        $.each data, (index, value) ->
          selected = if data[index].selected then data[index].id else null
          option = "<option value=\"#{data[index].id}\"> #{data[index].text} </option>"
          $("#student_application_project_session_id").append option
        $("#student_application_project_session_id").select2('val',selected)
        $("#student_application_project_session_id").valid()

  jQuery.validator.addMethod "student_application_agree_terms_accepted", ((value, element) ->
    @.optional(element) || $("#student_application_agree_terms").is(":checked")
  ), "You must agree the terms in order to continue"


  $('form[action^="/students/setup"]').validate
    errorElement: 'span'
    ignore: null
    highlight: (element, errorClass) ->
      $(element).parent().addClass "invalid"
    unhighlight: (element, errorClass) ->
      $(element).parent().removeClass "invalid"
    onfocusout: (element) ->
      $(element).valid()
    errorPlacement: errorPlacement

  if $('form[action="/students/setup/about_you"]').length > 0
    $("#your_project_select").rules "add",
      required: true
    $("#student_application_project_session_id").rules "add",
      required: true
    if $("#student_application_student_attributes_login_attributes_email").length > 0
      $("#student_application_student_attributes_login_attributes_email").rules "add",
        uniqueness: ["/unique/login/email", "email", true]
    if $("#student_application_student_attributes_login_attributes_password").length > 0
      $("#student_application_student_attributes_login_attributes_password").rules "add",
        required: true
        minlength: 8
    if $("#student_application_student_attributes_login_attributes_password_confirmation").length > 0
      $("#student_application_student_attributes_login_attributes_password_confirmation").rules "add",
        required: true
        minlength: 8
        equalTo: "#student_application_student_attributes_login_attributes_password"
    $("#student_application_student_attributes_marital_status").rules "add",
      required: true
    $("#student_application_student_attributes_birthday_3i").removeClass("date")
    $("#student_application_student_attributes_birthday_3i").rules "add",
      required: true
      min_length: 1
      max_length: 31
  
  if $('form[action="/students/setup/interests_and_fields_of_study"]').length > 0
    $("#student_application_student_attributes_graduation_year").rules "add",
      required: true
      number: true
    reference = "#student_application_student_attributes_person_references_attributes_"
    required_fields = (index) -> 
      ["#{reference}#{index}_contact_first_name", "#{reference}#{index}_contact_last_name", "#{reference}#{index}_contact_email"]
    $("#{reference}0_reference_id").rules "add", required: "#is_new_spiritual_reference[value='false']"
    $("#{reference}2_reference_id").rules "add", required: "#is_new_academic_reference[value='false']"
    $(element).rules "add", required: "#is_new_spiritual_reference[value='true']" for element in required_fields(1)
    $(element).rules "add", required: "#is_new_academic_reference[value='true']" for element in required_fields(3)
  
  if $('form[action="/students/setup/important_details"]').length > 0      
    $("#student_application_agree_terms").rules "add",
      required: true
      student_application_agree_terms_accepted: true

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
