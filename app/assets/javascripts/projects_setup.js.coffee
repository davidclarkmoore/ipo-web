ipo['projects_setup'] = {}
ipo['projects_setup']['show'] = ->

  connect_group_to_select $(".project_location_type.button_group"), $("#project_location_type")

  # Toggles checkbox based on element selected in a binary button group.
  # -- el:        element in button group that was clicked.
  # -- e:         click event.
  # -- active_id: button group that when active will select the checkbox
  # -- checkbox:  checkbox element tied to the button group.
  active_group_type = null
  window.select_group_element = (el, e, active_id, checkbox) ->
    e.preventDefault()
    if active_group_type
      active_group_type.removeClass("active button-green")
                       .addClass("button-grey")

    el.addClass("active button-green").removeClass("button-grey")
    active_group_type = el

    if el.attr('id') == active_id
      $(checkbox).attr('checked', 'checked')
    else
      $(checkbox).removeAttr('checked')

  $("#teams").click (e) ->
    select_group_element $(@), e, "teams", "#project_team_mode"

  $("#individuals").click (e) ->
    select_group_element $(@), e, "teams", "#project_team_mode"

  $("#public-location").click (e) ->
    select_group_element $(@), e, "private-location", "#project_location_private"

  $("#private-location").click (e) ->
    select_group_element $(@), e, "private-location", "#project_location_private"

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