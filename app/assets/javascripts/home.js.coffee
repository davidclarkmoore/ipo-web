# Connects button group to combobox. When button group is selected,
# value in hidden combobox is chosen.
window.connect_group_to_select = (group, select) ->
  select.hide()
  $("#s2id_" + select.attr('id')).hide() # hide select2 if shown.

  selected_button = null
  $(group).find("button").click (e) ->
    e.preventDefault()
    select.val $(@).data('value')

    if selected_button
      selected_button.removeClass("active button-green").addClass("button-grey")

    $(@).addClass("active button-green").removeClass("button-grey")
    selected_button = $(@)