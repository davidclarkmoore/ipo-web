ipo['projects_setup'] = {}
ipo['projects_setup']['show'] = ->

  connect_group_to_select $(".project_location_type.button_group")   , $("#project_location_type")
  connect_group_to_select $(".project_team_mode.button_group")       , $("#project_team_mode")
  connect_group_to_select $(".project_location_private.button_group"), $("#project_location_private")

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
      url: "/projects_setup/application_deadline/" + session_code
      success: (data) ->
        chooser.closest('.nested-fields').find('h5#field_for_deadline').html(data)  