$ ->
  $("input.date_picker").datepicker
    onChange: (dateText, inst) ->  $(inst.input).change().focusout()
    onClose: (dateText, inst) ->  $(inst.input).change().focusout()