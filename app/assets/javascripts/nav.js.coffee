$ ->
  $("input#search").focus ->
    if @value != ""
      @value = ""
      @className = "textinput"
    
  $("input#search").blur ->
    if @value == ""
      @value = "Search + Enter"
      @className = "placeholder"