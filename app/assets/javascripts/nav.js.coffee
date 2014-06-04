$ ->
  $("input#search").focus ->
    if @value == "Search + Enter"
      @value = ""
      @className = "textinput"
    
  $("input#search").blur ->
    if @value == ""
      @value = "Search + Enter"
      @className = "placeholder"