readyCallback = ->
  $('table.sortable').tablesorter({
    widgets: ["saveSort"],
    emptyTo: 'bottom',
    sortReset: 'true'
  })

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)