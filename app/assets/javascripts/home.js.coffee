# Override client side validations to work with select2 initialize client side validations to
# ClientSideValidations.selectors.validate_inputs += ', .select2-container:visible ~ :input:enabled[data-validate]';

# Connects button group to combobox. When button group is selected,
# value in hidden combobox is chosen.
window.connect_group_to_select = (group, select, onclick) ->
  selected_button = null
  $(group).find("button").click (e) ->
    e.preventDefault()
    select_button(@)
    onclick(select) if onclick

  select_button = (btn) ->
    select.val $(btn).data('value').toString()
    if selected_button
      selected_button.removeClass("active button-green").addClass("button-grey")

    $(btn).addClass("active button-green").removeClass("button-grey")
    selected_button = $(btn)


  # Detect pre-initialized values.
  if select.val()
    select_button select.siblings("[data-value='" + select.val() + "']")

$ ->
  $(".subpages").click ->
    page = $(this).attr("page")
    $("#sub_menus_#{page}").slideToggle("slow")

  $("#related_field_of_study").autocomplete
    source: "/home/autocomplete"
    select: (event,ui) -> $("#related_field_of_study").val(ui.item.id)

  $("#search-field-study").click (event)->
    event.preventDefault() if $("#q_address_cont").val().length == 0 and $("#related_field_of_study").val().length == 0

  $('#fields_and_areas .tab').click (e) ->
    $(@).addClass('active').siblings().first().removeClass 'active'
    $($(@).data('box')).show().siblings('.tab-box').first().hide()