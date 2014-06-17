$ ->
  $("input#search").focus ->
    if @value != ""
      @value = ""
      @className = "textinput"
    
  $("input#search").blur ->
    if @value == ""
      @value = "&#128269; Search + Enter"
      @className = "placeholder"