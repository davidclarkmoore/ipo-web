$ ->
  $("input.date_picker").datepicker
    onChange: (dateText, inst) ->  $(inst.input).change().focusout()
    onClose: (dateText, inst) ->  $(inst.input).change().focusout()

  $("#properties_related_fields_of_study, #properties_related_student_passions").select2
  	closeOnSelect: false
  	
  $('.bxslider').bxSlider
    pagerCustom: '#bx-pager'
    nextText: '&#59238;'
    prevText: '&#59237;'
