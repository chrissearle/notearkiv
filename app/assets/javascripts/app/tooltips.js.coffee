readyCallback = ->
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)