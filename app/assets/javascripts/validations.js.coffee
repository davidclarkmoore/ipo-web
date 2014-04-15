jQuery.validator.addMethod "uniqueness", ((value, element, params) ->
    #if value already exists in the database do not validate (for editing)
    return true if ($(element).data("name") == $(element).val())
    result = $.ajax(
      type: "GET"
      url: "#{params[0]}/#{value}"
      data: if params[2] then "case_sensitive=#{params[2]}" else ""
      dataType: "text"
      cache: false
      async: false
    ).responseText
    if result == "true" then true else false
  ), jQuery.validator.format("This {1} is already taken")

window.errorPlacement = (error, element) ->
  elem = $(element)
  if elem.is("input[type='radio'], input[type='checkbox']")
    $("<div>").append(error).insertAfter(elem.parent().siblings().last()) 
  else if elem.is("input:hidden")
    error.appendTo(elem.parent())
  else
    error.insertAfter(elem) 

#fix for checkboxes with hidden input
jQuery.validator.prototype.elementValue = (element) ->
  name = $(element).attr("name")
  type = $(element).attr("type")
  val = $(element).val()
  return $("input[name='#{name}'][type='#{type}']:checked").val() if type is "radio" or type is "checkbox"
  return val.replace(/\r/g, "")  if typeof val is "string"
  val

#fix - select2 and button_group gain focus after failed validation
jQuery.validator.prototype.focusInvalid = ->
  if @settings.focusInvalid
    try
      # manually trigger focusin event; without it, focusin handler isn't called, findLastActive won't have anything to find
      element = $(@errorList.length and @errorList[0].element)
      if element.is("select.select2-offscreen, select.button_group") 
        window.scrollTo(0, element.closest(":visible")[0].offsetTop - 100)
      else
        $(@findLastActive() or element or []).focus().filter(":visible").trigger "focusin"
  return