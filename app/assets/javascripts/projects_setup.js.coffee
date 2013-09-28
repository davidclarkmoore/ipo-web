ipo['projects_setup'] = {}
ipo['projects_setup']['show'] = ->

  connect_group_to_select $("#location-type"), $("#project_location_type")

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
      $(checkbox).prop('checked', true)
    else
      $(checkbox).prop('checked', false)

  $("#teams").click (e) ->
    select_group_element $(@), e, "teams", "#project_team_mode"

  $("#individuals").click (e) ->
    select_group_element $(@), e, "teams", "#project_team_mode"

  $("#public-location").click (e) ->
    select_group_element $(@), e, "private-location", "#project_location_private"

  $("#private-location").click (e) ->
    select_group_element $(@), e, "private-location", "#project_location_private"