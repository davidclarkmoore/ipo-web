ipo['projects_setup'] = {}
ipo['projects_setup']['show'] = ->

  connect_group_to_select $(".project_location_type.button_group")   , $("#project_location_type"), (select) -> select.valid()
  connect_group_to_select $(".project_team_mode.button_group")       , $("#project_team_mode"), (select) -> select.valid()
  connect_group_to_select $(".project_location_private.button_group"), $("#project_location_private"), (select) -> select.valid()

  $('#organizations .tab').click (e) ->
    $(@).addClass('active').siblings().first().removeClass 'active'
    $($(@).data('box')).show().siblings('.tab-box').first().hide()
    $('#is_new_organization').val(($(@).data('box') == "#new-organization"))

  $('#new_project_media').fileupload
    dataType: "script"
    dropZone: $("#drop_zone")
    add: (e, data) ->
      data.context = $(tmpl("template-upload", data.files[0]))
      $('#drop_zone').append(data.context)
      data.submit()
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
        if progress == 100
          data.context.fadeOut "slow", ->
            $(this).remove()

  $('.project_media').on "ajax:success", ".media form", (event, data, status, xhr) ->
    $(event.target).parent().fadeOut "slow", () ->
      $(this).remove()

ipo['projects_setup']['update'] = ipo['projects_setup']['show']

jQuery ->
  $("form").on "cocoon:after-insert", ->
    chooser_sessions = $('.session_chooser')
    last_one = chooser_sessions[chooser_sessions.length-1]
    $("#" + last_one.id).select2()

  $(document).on "change", "select.session_chooser", {}, (e) ->
    chooser = $(this)
    session_code = chooser.val()
    $.ajax
      type: "GET"
      url: "/projects_setup/application_deadline/" + session_code + ".json"
      success: (data) ->

        # TODO: This line is too fickle. Any slight change to the design/html
        # of session choosing breaks the find.
        chooser.closest('.student-requirements-illustration')
               .siblings('.student-requirements-fields')
               .find('.field_for_deadline')
               .html(data)

  # Validation method for agreements acceptation
  jQuery.validator.addMethod "project_agree_memo_accepted", (() ->
    $("#project_agree_memo").is(":checked")
  ), jQuery.validator.format("You must agree the terms in order to continue")

  jQuery.validator.addMethod "project_agree_to_transport_accepted", (() ->
    $("#project_agree_to_transport").is(":checked")
  ), jQuery.validator.format("You must agree the terms in order to continue")

  $('form[action^="/projects/setup"]').validate
    errorElement: 'span'
    ignore: null
    highlight: (element, errorClass) ->
      $(element).parent().addClass "invalid"
    unhighlight: (element, errorClass) ->
      $(element).parent().removeClass "invalid"
    onfocusout: (element) ->
      $(element).valid()
    errorPlacement: errorPlacement
  
  if $('form[action="/projects/setup/about_you"]').length > 0
    if $("#project_field_host_attributes_login_attributes_password").length > 0
      $("#project_field_host_attributes_login_attributes_password").rules "add",
        required: true
        minlength: 8
    if $("#project_field_host_attributes_login_attributes_password").length > 0
      $("#project_field_host_attributes_login_attributes_password_confirmation").rules "add",
        required: true
        minlength: 8
        equalTo: "#project_field_host_attributes_login_attributes_password"
    if $("#project_field_host_attributes_login_attributes_email").length > 0
      $("#project_field_host_attributes_login_attributes_email").rules "add",
        uniqueness: ["/unique/login/email","email"]
    $("#project_field_host_attributes_years_associated_with_organization").rules "add",
      required: true
      number: true
    $("#project_field_host_attributes_phone_type").rules "add",
      required: true  
    $("#project_organization_id").rules "add",
      required: "#is_new_organization[value='false']"
    $("#project_organization_attributes_name").rules "add",
      required: "#is_new_organization[value='true']"
    $("#project_organization_attributes_organization_type").rules "add",
      required: "#is_new_organization[value='true']"

  if $('form[action$="the_project"]').length > 0
    $("#project_team_mode").rules "add",
      required: true
    $("#project_name").rules "add",
      required: true
      uniqueness: ["/unique/project/name", "project name"]
    $("#project_min_students").rules "add",
      required: true
      number: true
    $("#project_max_students").rules "add",
      required: true
      number: true
    $("#project_student_educational_requirement").rules "add",
      required: true

  if $('form[action$="location"]').length > 0
    $("#project_location_private").rules "add",
      required: true
    $("#project_address").rules "add",
      required: true
    $("#project_internet_distance").rules "add",
      required: true
    $("#project_location_description").rules "add",
      required: true
    $("#project_culture_description").rules "add",
      required: true

  if $('form[action$="content"]').length > 0
    $("#project_description").rules "add",
      required: true
    $("#project_housing_type").rules "add",
      required: true
    $("#project_dining_location").rules "add",
      required: true
    $("#project_housing_description").rules "add",
      required: true
    $("#project_safety_level").rules "add",
      required: true
    $("#project_challenges_description").rules "add",
      required: true
    $("#project_typical_attire").rules "add",
      required: true
    $("#project_guidelines_description").rules "add",
      required: true

  if $('form[action$="agreement"]').length > 0
    $("#project_agree_memo").rules "add",
      project_agree_memo_accepted: true
    $("#project_agree_to_transport").rules "add",
      project_agree_to_transport_accepted: true 

  