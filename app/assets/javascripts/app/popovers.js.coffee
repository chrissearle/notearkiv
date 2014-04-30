readyCallback = ->
  $("a[rel=popover]").popover()
  $(".btn-danger").popover()


$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)