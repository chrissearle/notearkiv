jQuery ->
  $('#mainsearch').typeahead(
    minLength: 3,
    source: (query, typeahead) ->
      $.ajax(
        url: $('#mainsearch').data('typeahead-link') + "?search=" + query
        success: (data) =>
          typeahead(data)
      )
  )