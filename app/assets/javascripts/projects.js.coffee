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



  map = undefined
  initialize = ->
    mapOptions =
      zoom: 8
      center: new google.maps.LatLng(-34.397, 150.644)

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    return

  codeAddress = ->
    address = document.getElementById("address").value
    geocoder.geocode
      address: address
    , (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        map.setCenter results[0].geometry.location
        marker = new google.maps.Marker(
          map: map
          position: results[0].geometry.location
        )
      else
        alert "Geocode was not successful for the following reason: " + status
      return

    return


  google.maps.event.addDomListener window, "load", initialize