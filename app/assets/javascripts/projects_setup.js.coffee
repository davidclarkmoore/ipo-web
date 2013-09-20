ipo['projects_setup'] = {}
ipo['projects_setup']['show'] = ->
  active_project_type = null
  team_select_click = (el, e) ->
    e.preventDefault()
    if active_project_type
      active_project_type.removeClass("active").removeClass("button-green").addClass("button-grey")
    el.addClass("active").addClass("button-green").removeClass("button-grey")
    active_project_type = el

    if el.attr('id') == 'teams'
      $("#project_team_mode").prop('checked', true)
    else
      $("#project_team_mode").prop('checked', false)




  $("#teams").click (e) -> team_select_click $(@), e
  $("#individuals").click (e) -> team_select_click $(@), e