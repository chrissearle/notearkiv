# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .

sorted = (table) ->
  sorting = [];
  $(table).find(".header").each ->
    if ($(this).hasClass("headerSortDown"))
      sorting.push {
        column: $(this).data('col'),
        direction: 'ASC'
      }
    if ($(this).hasClass("headerSortUp"))
      sorting.push {
        column: $(this).data('col'),
        direction: 'DESC'
      }
  if sorting.length > 0
    $.ajax({
      type: "POST",
      url: $(table).data('sorted'),
      data: { 'sorting': sorting }
    })

jQuery ->
  $("table.sortable.evensong").tablesorter({
    sortList: [[0,0]],
    headers: {4: {sorter: false}}
  })

  $("table.sortable.note").tablesorter({
    sortList: [[1,0]],
    headers: {7: {sorter: false}}
  })

  $("table.sortable.note").bind("sortEnd", ->
    sorted(this)
    )

  $("table.sortable.evensong").bind("sortEnd", ->
    sorted(this)
    )

  $('#mainsearch').typeahead(
    minLength: 3,
    source: (query, typeahead) ->
      $.ajax(
        url: $('#mainsearch').data('typeahead-link') + "?search=" + query
        success: (data) =>
          typeahead(data)
      )
  )