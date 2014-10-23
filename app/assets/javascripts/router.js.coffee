ipo =
  common:
    init:
      $(document).ready ->
        $(".box-grey select").select2({minimumResultsForSearch: -1});
        $('select').not('.no-select2').select2();
        chkbox_selector = "input[data-toggle='checkbox']";
        $("label.checkbox").off("focusin", chkbox_selector).on("focusin", chkbox_selector, () -> 
          $(this).parent().addClass('focusin'))
        $("label.checkbox").off("focusout", chkbox_selector).on("focusout", chkbox_selector, () -> 
          $(this).parent().removeClass('focusin'))
        radio_selector = "input[data-toggle='radio']";
        $("label.radio").off("focusin", radio_selector).on("focusin", radio_selector, () -> 
          $(this).parent().addClass('focusin'))
        $("label.radio").off("focusout", radio_selector).on("focusout", radio_selector, () -> 
          $(this).parent().removeClass('focusin'))

window.ipo = ipo

UTIL =
  exec: (controller, action) ->
    ns = ipo
    action = (if (action is `undefined`) then "init" else action)
    ns[controller][action]()  if controller isnt "" and ns[controller] and typeof ns[controller][action] is "function"

  init: ->
    body = document.body
    controller = $('body').data "controller"
    action = $('body').data "action"
    UTIL.exec "common"
    UTIL.exec controller
    UTIL.exec controller, action

$ ->
  app = $('body').data "application"
  if app is 'ipo'
    UTIL.init()

