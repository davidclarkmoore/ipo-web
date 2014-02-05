ipo['dashboards'] = {}
ipo['dashboards']['index'] = ->

  connect_group_to_select $(".student_published_status.button_group") , $("#student_published_status")

ipo['dashboards']['update'] = ipo['dashboards']['index']