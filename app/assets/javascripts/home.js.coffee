# Connects button group to combobox. When button group is selected,
# value in hidden combobox is chosen.
window.connect_group_to_select = (group, select) ->
  selected_button = null
  $(group).find("button").click (e) ->
    e.preventDefault()
    select_button(@)

  select_button = (btn) ->
    select.val $(btn).data('value').toString()
    if selected_button
      selected_button.removeClass("active button-green").addClass("button-grey")

    $(btn).addClass("active button-green").removeClass("button-grey")
    selected_button = $(btn)


  # Detect pre-initialized values.
  if select.val()
    select_button select.siblings("[data-value='" + select.val() + "']")
    # console.log select.val()
