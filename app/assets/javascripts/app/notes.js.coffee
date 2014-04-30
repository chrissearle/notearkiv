readyCallback = ->
  $('#note_voice').typeahead(
    minLength: 2,
    source: (query, typeahead) ->
      $.ajax(
        url: $('#note_voice').data('typeahead-link') + "?search=" + query
        success: (data) ->
          typeahead(data)
      )
  )

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)