ipo['dashboards'] = {}
ipo['dashboards']['index'] = ->
  connect_group_to_select $(".student_published_status.button_group") , $("#student_published_status")

  $('#profile_picture_upload').fileupload
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


   $('.saved-images').on "ajax:success", ".media form", (event, data, status, xhr) ->
    $(event.target).parent().fadeOut "slow", () ->
      $(this).remove()

ipo['dashboards']['update'] = ipo['dashboards']['index']